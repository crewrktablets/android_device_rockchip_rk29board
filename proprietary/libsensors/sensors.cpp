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
//#define FUNC_LOG ALOGV("++++++++++ > %s", __PRETTY_FUNCTION__)
#define FUNC_LOG
 
#include <utils/Log.h>

#include <hardware/sensors.h>

#include "nusensors.h"

/*****************************************************************************/

/* The SENSORS Module */
#define LOCAL_SENSORS (1)
static struct sensor_t sSensorList[LOCAL_SENSORS] = {
        { "MMA7660FC XYZ-AXIS ACCELEROMETER",
          "Freescale",
          1, 
		  SENSORS_HANDLE_BASE+ID_A,
          SENSOR_TYPE_ACCELEROMETER, 
		  4.0f*9.81f, 
		  (4.0f*9.81f)/256.0f, 
		  0.2f, 
		  0, 
		  { } 
		},
};

static int numSensors = LOCAL_SENSORS;

static int open_sensors(const struct hw_module_t* module, const char* id,
                        struct hw_device_t** device);


static int sensors__get_sensors_list(struct sensors_module_t* module,
                                     struct sensor_t const** list)
{
    *list = sSensorList;
    return numSensors;
}

static struct hw_module_methods_t sensors_module_methods = {
        open: open_sensors
};

struct sensors_module_t HAL_MODULE_INFO_SYM = {
    common: {
        tag: HARDWARE_MODULE_TAG,
		version_major: 1,
		version_minor: 0,
        id: SENSORS_HARDWARE_MODULE_ID,
        name: "MMA7660FC Sensors Module",
        author: "joaquim.org - BQPascal 2",
        methods: &sensors_module_methods,
		dso: 0,
		reserved: {},
    },
    get_sensors_list: sensors__get_sensors_list,
};

/*****************************************************************************/

static int open_sensors(const struct hw_module_t* module, const char* name, struct hw_device_t** device) {

	FUNC_LOG;
    return init_nusensors(module, device);
}
