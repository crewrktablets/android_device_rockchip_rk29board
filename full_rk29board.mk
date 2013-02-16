# Inherit device configuration
$(call inherit-product, device/rockchip/rk29board/device.mk)

# Release name
PRODUCT_RELEASE_NAME := rk29board

## Device identifier. This must come after all inclusions
# Set those variables here to overwrite the inherited values.
PRODUCT_NAME := full_rk29board
PRODUCT_DEVICE := rk29board
PRODUCT_BRAND := Android
PRODUCT_MODEL := AOSP on rk29board
PRODUCT_MANUFACTURER := Rockchip
