MKBOOTIMG := device/samsung/a10/mkbootimg

TWRP_DEVICE := a10
TWRP_VERSION := 3.5.0_9
TWRP_BUILD_TYPE := Unofficial
TWRP_BUILD_DATE := $(shell date --utc +%Y%m%d)
 
TWRP_OUT_NAME := $(PRODUCT_OUT)/TWRP_$(TWRP_VERSION)_$(TWRP_DEVICE)_$(TWRP_BUILD_DATE)_$(TWRP_BUILD_TYPE)

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(BOOTIMAGE_EXTRA_DEPS)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) echo -n "SEANDROIDENFORCE" >> $@
	@echo "Made boot image: $@"

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel) $(RECOVERYIMAGE_EXTRA_DEPS)
	@echo "----- Making recovery image ------"
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	@echo "----- Lying about SEAndroid state to Samsung bootloader ------"
	$(hide) echo -n "SEANDROIDENFORCE" >> $@
	$(hide) cp $@ $(TWRP_OUT_NAME)".img"
	@echo "Made recovery image: $@"
	$(hide) tar -C $(PRODUCT_OUT) -H ustar -c recovery.img > $(TWRP_OUT_NAME)".tar"
	@echo "Made flashable $(FLASH_IMAGE_TARGET): $@"
