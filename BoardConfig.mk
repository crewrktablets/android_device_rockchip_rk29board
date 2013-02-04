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

# WLAN
#BOARD_WLAN_DEVICE             := bcm94319wlusbn4l
#BOARD_SOFTAP_DEVICE           := bcm94319wlusbn4l
WPA_SUPPLICANT_VERSION        := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER   := WEXT
WIFI_DRIVER_MODULE_PATH       := "/system/lib/modules/wlan.ko"
#WIFI_DRIVER_FW_STA_PATH       := "/system/etc/firmware/fw_bcm4329.bin"
#WIFI_DRIVER_FW_AP_PATH        := "/system/etc/firmware/fw_bcm4329_apsta.bin"
#WIFI_DRIVER_MODULE_ARG        := "iface_name=wlan0 firmware_path=/system/etc/firmware/fw_bcm4329.bin nvram_path=/system/etc/firmware/nvram.txt"
WIFI_DRIVER_MODULE_NAME       := "wlan"

# Graphics
BOARD_EGL_CFG := device/rockchip/rk29board/egl.cfg
TARGET_BOARD_PLATFORM_GPU := VIVANTE
BOARD_USES_VIVANTE := true
USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true
COMMON_GLOBAL_CFLAGS += -DSURFACEFLINGER_FORCE_SCREEN_RELEASE -DNO_RGBX_8888 -DMISSING_GRALLOC_BUFFERS

# Audio
#BOARD_USES_GENERIC_AUDIO := true
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_AUDIO_LEGACY := true

# Camera Setup
#BOARD_USES_LEGACY_CAMERA := true
USE_CAMERA_STUB := true
#BOARD_CAMERA_USE_MM_HEAP := true

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
BOARD_HAS_SDCARD_INTERNAL := true

# Vold
BOARD_VOLD_MAX_PARTITIONS := 12
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/class/android_usb/f_mass_storage/lun%d/file"
