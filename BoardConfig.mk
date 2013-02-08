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
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
ARCH_ARM_HAVE_TLS_REGISTER := true

# Use a smaller subset of system fonts to keep image size lower
SMALLER_FONT_FOOTPRINT := true
#MINIMAL_FONT_FOOTPRINT := true

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/generic/common/bluetooth

# Gsensor board config
# we can use this string : mma7660, mxc622x, bma250
SW_BOARD_USES_GSENSOR_TYPE := mma7660
SW_BOARD_GSENSOR_DIRECT_X := true
SW_BOARD_GSENSOR_DIRECT_Y := false
SW_BOARD_GSENSOR_DIRECT_Z := true
SW_BOARD_GSENSOR_XY_REVERT := true

# Wifi related defines
BOARD_WPA_SUPPLICANT_DRIVER := WEXT
WPA_SUPPLICANT_VERSION      := VER_0_8_X

# Wifi chipset select
# usb wifi "bcm94319"; sdio wifi "wlusbn4" ARNOVA 8G2I Tabs
SW_BOARD_USR_WIFI := bcm94319

# no gps,even default
BOARD_USES_GPS_TYPE := nogps

# Graphics
BOARD_EGL_CFG := device/rockchip/rk29board/egl.cfg
TARGET_BOARD_PLATFORM_GPU := VIVANTE
#BOARD_USES_VIVANTE := true
USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true
COMMON_GLOBAL_CFLAGS += -DSURFACEFLINGER_FORCE_SCREEN_RELEASE -DNO_RGBX_8888 -DMISSING_GRALLOC_BUFFERS
SW_BOARD_ROTATION_180 = true

# no hardware camera
USE_CAMERA_STUB := true

# Audio
HAVE_HTC_AUDIO_DRIVER := true
BOARD_USES_GENERIC_AUDIO := true
#BOARD_USES_ALSA_AUDIO := true
#BOARD_USES_AUDIO_LEGACY := true

# Gps 
# simulator :taget board does not have a gps hardware module;
BOARD_USES_GPS_TYPE := simulator

# use our own su for root
BOARD_USES_ROOT_SU := true

# No HWCOMPOSER - TO DO
BOARD_USES_HWCOMPOSER := false

# Misc display settings
BOARD_USE_SKIA_LCDTEXT := true
BOARD_HAVE_VPU := true

# Enable WEBGL in WebKit
ENABLE_WEBGL := true
TARGET_FORCE_CPU_UPLOAD := true

# USB Mass Storage. Original path := /sys/devices/platform/usb_mass_storage/lun0/file
#TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/??

# Indicate that the board has an Internal SD Card
BOARD_SDCARD_INTERNAL_DEVICE := /dev/block/mmcblk0p1
BOARD_HAS_SDCARD_INTERNAL := true

# Vold
BOARD_VOLD_MAX_PARTITIONS := 20
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/class/android_usb/f_mass_storage/lun0/file

# hardware module include file path
# TARGET_HARDWARE_INCLUDE := /device/rk29board/include
