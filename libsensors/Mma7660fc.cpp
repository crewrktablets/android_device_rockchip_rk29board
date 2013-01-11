/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_NDEBUG 0
#define LOG_TAG "Sensors"

#include <fcntl.h>
#include <errno.h>
#include <math.h>
#include <poll.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/select.h>

#include <cutils/log.h>

#include "Mma7660fc.h"

/*****************************************************************************/
//:TODO: g-sensor should be complied with the driver interface
Mma7660fc::Mma7660fc()
: SensorBase(MMA_DEVICE_NAME, MMA_DATA_NAME),
      mEnabled(0),
      mPendingMask(0),
      mInputReader(32)
{
    memset(mPendingEvents, 0, sizeof(mPendingEvents));

    mPendingEvents[Accelerometer].version = sizeof(sensors_event_t);
    mPendingEvents[Accelerometer].sensor = ID_A;
    mPendingEvents[Accelerometer].type = SENSOR_TYPE_ACCELEROMETER;
    mPendingEvents[Accelerometer].acceleration.status = SENSOR_STATUS_ACCURACY_HIGH;    

    for (int i=0 ; i<numSensors ; i++)
        mDelays[i] = 30000000LLU; // 30 ms by default
  
	if (!mEnabled) {
        close_device();
    }
}

Mma7660fc::~Mma7660fc() {
}

int Mma7660fc::enable(int32_t handle, int en)
{    
	int what = -1;
    switch (handle) {
        case ID_A: what = Accelerometer; break;
        //case ID_O: what = Orientation;   break;
    }
 
    if (uint32_t(what) >= numSensors)
        return -EINVAL;
 
    int newState = en ? 1 : 0;
    int err = 0;
 
	ALOGD("Mma7660fc: enable()  newState : %d | mEnabled : %d ", newState, mEnabled);
 
    if ((uint32_t(newState) << what) != (mEnabled & (1 << what)))
    {
        if (!mEnabled) {
            open_device();
        }

		short flags = newState;
		
		if ( newState == 1 ) {
			
			err = ioctl(dev_fd, ECS_IOCTL_START); // , &flags
			err = err < 0 ? -errno : 0;
	 
			ALOGE_IF(err, "Mma7660fc: ECS_IOCTL_START failed (%s) ", strerror(-err));
			
		} else {

			err = ioctl(dev_fd, ECS_IOCTL_CLOSE); // , &flags
			err = err < 0 ? -errno : 0;
	 
			ALOGE_IF(err, "Mma7660fc: ECS_IOCTL_CLOSE failed (%s) ", strerror(-err));
		}

        if (!err) {
            mEnabled &= ~(1<<what);
            mEnabled |= (uint32_t(flags)<<what);
            update_delay();
        }
        if (!mEnabled) {
            close_device();
        }
    }
 
    return err;
}

int Mma7660fc::setDelay(int32_t handle, int64_t ns)
{
    int what = -1;
    switch (handle) {
        case ID_A: what = Accelerometer; break;
        //case ID_O: what = Orientation;   break;
    }

    if (uint32_t(what) >= numSensors)
        return -EINVAL;

    if (ns < 0)
        return -EINVAL;

    mDelays[what] = ns;
    return update_delay();

}

int Mma7660fc::update_delay()
{
    if (mEnabled) {
        uint64_t wanted = -1LLU;
        for (int i=0 ; i<numSensors ; i++) {
            if (mEnabled & (1<<i)) {
                uint64_t ns = mDelays[i];
                wanted = wanted < ns ? wanted : ns;
            }
        }
        short delay = int64_t(wanted) / 1000000;
		
		/*
		FROM : Freescale Semiconductor Technical Data, Document Number: MMA7660FC
		
		$08: Auto-Wake and Active Mode Portrait/Landscape Samples per Seconds Register (Read/Write)
		SR — Sample Rate Register
		
		D7 		D6 		D5 		D4 		D3 		D2 		D1 		D0
		FILT[2] FILT[1] FILT[0] AWSR[1] AWSR[0] AMSR[2] AMSR[1] AMSR[0]
		
		AMSR[2:0] 	NAME 	DESCRIPTION
		000 		AMPD 	Tap Detection Mode and 120 Samples/Second Active and Auto-Sleep Mode
		001 		AM64 	64 Samples/Second Active and Auto-Sleep Mode
		010 		AM32 	32 Samples/Second Active and Auto-Sleep Mode
		011 		AM16 	16 Samples/Second Active and Auto-Sleep Mode
		100 		AM8 	8 Samples/Second Active and Auto-Sleep Mode
		101 		AM4 	4 Samples/Second Active and Auto-Sleep Mode
		110 		AM2 	2 Samples/Second Active and Auto-Sleep Mode
		111 		AM1 	1 Sample/Second Active and Auto-Sleep Mode
		
		AWSR[1:0] 	NAME 	DESCRIPTION
		00 			AW32 	32 Samples/Second Auto-Wake Mode
		01 			AW16 	16 Samples/Second Auto-Wake Mode
		10 			AW8 	8 Samples/Second Auto-Wake Mode
		11 			AW1 	1 Sample/Second Auto-Wake Mode
		
		FILT[2:0] 	DESCRIPTION
		000 		Tilt debounce filtering is disabled. The device updates portrait/landscape every reading at the rate set by AMSR[2:0] or AWSR[1:0]
		001 		2 measurement samples at the rate set by AMSR[2:0] or AWSR[1:0] have to match before the device updates portrait/landscape data in TILT (0x03) register.
		010 		3 measurement samples at the rate set by AMSR[2:0] or AWSR[1:0] have to match before the device updates portrait/landscape data in TILT (0x03) register.
		011 		4 measurement samples at the rate set by AMSR[2:0] or AWSR[1:0] have to match before the device updates portrait/landscape data in TILT (0x03) register.
		100 		5 measurement samples at the rate set by AMSR[2:0] or AWSR[1:0] have to match before the device updates portrait/landscape data in TILT (0x03) register.
		101 		6 measurement samples at the rate set by AMSR[2:0] or AWSR[1:0] have to match before the device updates portrait/landscape data in TILT (0x03) register.
		110 		7 measurement samples at the rate set by AMSR[2:0] or AWSR[1:0] have to match before the device updates portrait/landscape data in TILT (0x03) register.
		111 		8 measurement samples at the rate set by AMSR[2:0] or AWSR[1:0] have to match before the device updates portrait/landscape data in TILT (0x03) register.
		
		*/
		
		if ( delay > 32 ) {
			delay = 3;
		}
        ALOGD("Mma7660fc: update_delay  %d", delay);        
		if (ioctl(dev_fd, ECS_IOCTL_APP_SET_RATE, &delay))
            return -errno;
    }
    return 0;
}

int Mma7660fc::readEvents(sensors_event_t* data, int count)
{
    if (count < 1)
        return -EINVAL;

    ssize_t n = mInputReader.fill(data_fd);
    if (n < 0)
        return n;

    int numEventReceived = 0;
    input_event const* event;

    while (count && mInputReader.readEvent(&event)) {
        int type = event->type;
		
		//ALOGD("Mma7660fc: event (type=%d, code=%d)", type, event->code);
		
        if (type == EV_ABS) {
            processEvent(event->code, event->value);
            mInputReader.next();
        } else if (type == EV_SYN) {
            int64_t time = timevalToNano(event->time);
            for (int j=0 ; count && mPendingMask && j<numSensors ; j++) {
                if (mPendingMask & (1<<j)) {
                    mPendingMask &= ~(1<<j);
                    mPendingEvents[j].timestamp = time;
                    if (mEnabled & (1<<j)) {
                        *data++ = mPendingEvents[j];
                        count--;
                        numEventReceived++;
                    }
                }
            }
            if (!mPendingMask) {
                mInputReader.next();
            }
        } else {
            ALOGE("Mma7660fc: unknown event (type=%d, code=%d)", type, event->code);
            mInputReader.next();
        }
    }

    return numEventReceived;
}

void Mma7660fc::processEvent(int code, int value)
{
	/*		
		KERNEL 	LIB 	ANDROID
		X		X		X
		-Z		Y		Y
		Y		Z		Z
	*/
    switch (code) {
        case EVENT_TYPE_ACCEL_X:
            mPendingMask |= 1<<Accelerometer;
            mPendingEvents[Accelerometer].acceleration.x = (value * CONVERT_A_X);
            //ALOGD("Mma7660fc: mPendingEvents[Accelerometer].acceleration.x = %f",mPendingEvents[Accelerometer].acceleration.x);
            break;
        case EVENT_TYPE_ACCEL_Y:
            mPendingMask |= 1<<Accelerometer;
            mPendingEvents[Accelerometer].acceleration.y = (value * CONVERT_A_Y);
            //ALOGD("Mma7660fc: mPendingEvents[Accelerometer].acceleration.y = %f",mPendingEvents[Accelerometer].acceleration.y);
            break;
        case EVENT_TYPE_ACCEL_Z:
            mPendingMask |= 1<<Accelerometer;
            mPendingEvents[Accelerometer].acceleration.z = (value * CONVERT_A_Z);
            //ALOGD("Mma7660fc: mPendingEvents[Accelerometer].acceleration.z = %f",mPendingEvents[Accelerometer].acceleration.z);
            break;        
        
        /*case EVENT_TYPE_ORIENT_STATUS:
            mPendingMask |= 1<<Orientation;
            mPendingEvents[Orientation].orientation.status =
                    uint8_t(value & SENSOR_STATE_MASK);
            break;
		*/
    }
	//ALOGD("++++ > X:%05f Y:%05f Z:%05f",mPendingEvents[Accelerometer].acceleration.x, mPendingEvents[Accelerometer].acceleration.y, mPendingEvents[Accelerometer].acceleration.z);
}
