# config.mk
#
# Product-specific compile-time definitions.
#

# The generic product target doesn't have any hardware-specific pieces.
TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := true

PRODUCT_CHARACTERISTICS := tablet

TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_ARCH_VARIANT_CPU := cortex-a8
ARCH_ARM_HAVE_NEON := true
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_GLOBAL_CFLAGS += -mtune=cortex-a8 -mfpu=neon
# -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a8 -mfpu=neon
# -mfloat-abi=softfp
TARGET_BOARD_PLATFORM := rk29board
TARGET_BOARD_HARDWARE := rk29board

# Use a smaller subset of system fonts to keep image size lower
SMALLER_FONT_FOOTPRINT := true
#MINIMAL_FONT_FOOTPRINT := true

TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel

# Init
TARGET_PROVIDES_INIT := true
TARGET_PROVIDES_INIT_TARGET_RC := true
TARGET_RECOVERY_INITRC := $(LOCAL_PATH)/recovery/init.rc

# Recovery
BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/rockchip/rk29board/recovery/recovery_keys.c
BOARD_UMS_2ND_LUNFILE := "/sys/class/android_usb/android0/f_mass_storage/lun1/file"
BOARD_UMS_LUNFILE := "/sys/class/android_usb/android0/f_mass_storage/lun0/file"
BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_HAS_LARGE_FILESYSTEM := true


# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/rockchip/rk29board/bluetooth
BOARD_BLUEDROID_VENDOR_CONF := device/rockchip/rk29board/bluetooth/vnd_rockchip.txt

# WLAN
BOARD_WPA_SUPPLICANT_DRIVER := WEXT
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := WEXT
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE           := bcmdhd
WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/wlan.ko"
WIFI_DRIVER_MODULE_NAME     := "wlan"

# Graphics
BOARD_EGL_CFG := device/rockchip/rk29board/egl.cfg
USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true

# Audio
#BOARD_USES_GENERIC_AUDIO := true
#BOARD_USES_ALSA_AUDIO := true

# Camera Setup
#BOARD_USES_LEGACY_CAMERA := true
USE_CAMERA_STUB := true
#BOARD_CAMERA_USE_MM_HEAP := true

# No HWCOMPOSER - TO DO
BOARD_USES_HWCOMPOSER := true

# Misc display settings
BOARD_USE_SKIA_LCDTEXT := true
BOARD_HAVE_VPU := true

# Enable WEBGL in WebKit
ENABLE_WEBGL := true
TARGET_FORCE_CPU_UPLOAD := true

# Sensor
#BOARD_SENSOR_ST := true
#BOARD_SENSOR_NORMAL := true
#BOARD_SENSOR_MID := true   #error
#BOARD_SENSOR_MPU := true

# Vold
BOARD_VOLD_MAX_PARTITIONS := 12
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/class/android_usb/f_mass_storage/lun%d/file"
