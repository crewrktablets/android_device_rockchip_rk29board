  # config.mk
#
# Product-specific compile-time definitions.
#

# The generic product target doesn't have any hardware-specific pieces.
TARGET_NO_BOOTLOADER := true

TARGET_NO_KERNEL := true
# TARGET_PREBUILT_KERNEL := kernel/rockchip/rk29board
TARGET_KERNEL_SOURCE := kernel/rockchip/rk29board
# TARGET_KERNEL_CONFIG := odys_loox_plus_defconfig

# KERNEL_EXTERNAL_MODULES:
#	make -C device/rockchip/rk29board/vivante/ KERNEL_DIR=$(KERNEL_OUT) ARCH="arm" CROSS_COMPILE="arm-eabi-" CONFIG_VIVANTE=m
#	mv device/rockchip/rk29board/vivante/galcore.ko $(KERNEL_MODULES_OUT)
# TARGET_KERNEL_MODULES := KERNEL_EXTERNAL_MODULES

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
 
# create EXT4 images
TARGET_USERIMAGES_USE_EXT4 := true

# Max image/partition sizes
#BOARD_BOOTIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x00100000)
#BOARD_RECOVERYIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x00100000)
#BOARD_SYSTEMIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x07500000)
#BOARD_USERDATAIMAGE_MAX_SIZE := $(call image-size-from-data-size,0x04ac0000)

#defined image/partition sizes
BOARD_SYSTEMIMAGE_PARTITION_SIZE   :=  471859200		# 450 MB
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2621440000		# 2.5 GB
BOARD_FLASH_BLOCK_SIZE := 512

# Use a smaller subset of system fonts to keep image size lower
SMALLER_FONT_FOOTPRINT := true
#MINIMAL_FONT_FOOTPRINT := true

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/generic/common/bluetooth

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
# BOARD_USE_LEGACY_UI := true
# NUM_FRAMEBUFFER_SURFACE_BUFFERS := 2

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

# Vold
BOARD_VOLD_MAX_PARTITIONS := 12
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/class/android_usb/f_mass_storage/lun%d/file"

