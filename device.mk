# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# default is nosdcard, S/W button enabled in resource
DEVICE_PACKAGE_OVERLAYS := device/rockchip/rk29board/overlay
#PRODUCT_CHARACTERISTICS := nosdcard

# Copy prebuilt etcs
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/prebuilt/etc,system/etc)

# Copy prebuilt hw libs
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/prebuilt/lib/hw,system/lib/hw)

# Copy prebuilt egl libs
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/prebuilt/lib/egl,system/lib/egl)

# Copy every prebuilt libs
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/prebuilt/lib,system/lib)

# Copy prebuilt modules
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/prebuilt/lib/modules,system/lib/modules)

# Copy Vendor firmware
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/prebuilt/etc/firmware,system/etc/firmware)

# Copy keylayouts
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/prebuilt/usr/keylayout,system/usr/keylayout)

# Touchscreen driver
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/touchscreen,system/usr/idc)

# Copy ramdisk files
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/ramdisk,root)

# copy Rktools
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk29board/rktools,rktools)

# copy the builder 
PRODUCT_COPY_FILES += \
	device/rockchip/rk29board/custom_boot.sh:custom_boot.sh

# These are the hardware-specific feature permissions
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
        frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
        frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
        frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
        frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
        frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
        frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
        frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
        frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
        frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
        frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
        frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
        frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

# Build.prop 
PRODUCT_PROPERTY_OVERRIDES += \
        persist.sys.timezone=Europe/Berlin \
        persist.sys.language=de \
        persist.sys.country=DE \
        ro.sf.lcd_density=160 \
        ro.kernel.android.checkjni=1 \
        persist.sys.ui.hw=true \
        opengl.vivante.texture=1 \
        ro.opengles.version=131072 \
        hwui.render_dirty_regions=false \
        qemu.hw.mainkeys=0 \
        wifi.interface=wlan0

# enable ADB
#PRODUCT_PROPERTY_OVERRIDES := \
#        service.adb.root=1 \
#        ro.secure=0 \
#        ro.allow.mock.location=1 \
#        ro.debuggable=1

# Camera
PRODUCT_PACKAGES += \
        Camera \
        camera.rk29board

# Audio
PRODUCT_PACKAGES += \
   	audio.primary.default \
	audio.primary.rk29board \
	audio_policy.default \
	tinyplay \
   	tinycap \
    	tinymix \
	audio.a2dp.default \
    	audio.usb.default \
    	libtinyalsa \
    	libaudioutils

# Hal modules
PRODUCT_PACKAGES += \
	lights.rk29board \
   	power.rk29board \
        sensors.rk29board

PRODUCT_PACKAGES += \
        librs_jni \
        com.android.future.usb.accessory

# Filesystem management tools    
PRODUCT_PACKAGES += \
        make_ext4fs \
        setup_fs \
        static_busybox \
        utility_make_ext4fs \
        libstagefrighthw

# Fix for dalvik-cache
PRODUCT_PROPERTY_OVERRIDES += \
	dalvik.vm.dexopt-data-only=1

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
        service.adb.root=1 \
        ro.secure=0 \
        ro.allow.mock.location=1 \
        ro.debuggable=1 \
        persist.sys.usb.config=mtp

# android core stuff
$(call inherit-product, frameworks/native/build/tablet-dalvik-heap.mk)
$(call inherit-product, build/target/product/full_base.mk)

