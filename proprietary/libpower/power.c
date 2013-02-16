/*
 * Copyright (C) 2012 The Android Open Source Project
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
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define LOG_TAG "RKPowerHAL"
#include <utils/Log.h>

#include <hardware/hardware.h>
#include <hardware/power.h>

#define INTERACTIVE_PATH "/sys/devices/system/cpu/cpufreq/interactive/"

static void sysfs_write(char *path, char *s)
{
    //char buf[80];
    int len;
    int fd = open(path, O_WRONLY);

    if (fd < 0) {
        //strerror_r(errno, buf, sizeof(buf));
        //ALOGE("Error opening %s: %s\n", path, buf);
        return;
    }

    len = write(fd, s, strlen(s));
    if (len < 0) {
        //strerror_r(errno, buf, sizeof(buf));
        //ALOGE("Error writing to %s: %s\n", path, buf);
    }

    close(fd);
}

static void rk_power_init(struct power_module *module)
{
    /*
     * cpufreq interactive governor: timer 20ms, min sample 20ms,
     * hispeed 816MHz at load 85%.
     */

    ALOGD("init\n");
    sysfs_write(INTERACTIVE_PATH "timer_rate", "20000");
    sysfs_write(INTERACTIVE_PATH "min_sample_time", "20000");
    sysfs_write(INTERACTIVE_PATH "hispeed_freq", "816000");
    sysfs_write(INTERACTIVE_PATH "go_hispeed_load", "85");
    sysfs_write(INTERACTIVE_PATH "above_hispeed_delay", "100000");
}

static void rk_power_set_interactive(struct power_module *module, int on)
{
    /*
     * Lower maximum frequency when screen is off. CPU 0 and 1 share a
     * cpufreq policy.
     */

    sysfs_write("/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq", on ? "1608000" : "816000");
    sysfs_write(INTERACTIVE_PATH "input_boost", on ? "1" : "0");
    //sysfs_write("/sys/devices/system/cpu/cpu1/online", on ? "1" : "0");
}

static void rk_power_hint(struct power_module *module, power_hint_t hint, void *data)
{
    switch (hint) {
    case POWER_HINT_INTERACTION:
        break;

    case POWER_HINT_VSYNC:
        break;

    default:
        break;
    }
}

static struct hw_module_methods_t power_module_methods = {
    .open = NULL,
};

struct power_module HAL_MODULE_INFO_SYM = {
    common: {
        tag: HARDWARE_MODULE_TAG,
        module_api_version: POWER_MODULE_API_VERSION_0_2,
        hal_api_version: HARDWARE_HAL_API_VERSION,
        id: POWER_HARDWARE_MODULE_ID,
        name: TARGET_BOARD_PLATFORM " Power HAL",
        author: "Rockchip",
        methods: &power_module_methods,
    },

    init: rk_power_init,
    setInteractive: rk_power_set_interactive,
    powerHint: rk_power_hint,
};
