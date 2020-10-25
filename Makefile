# ARCHS = arm64
TARGET = iphone:clang:13.5

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LastTime

LastTime_FILES = Tweak.x
LastTime_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
