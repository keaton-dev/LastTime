ARCHS = arm64 arm64e
TARGET = iphone:clang:13.5

INSTALL_TARGET_PROCESSES = SpringBoard
GO_EASY_ON_ME=1
#FINALPACKAGE=1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LastTime

LastTime_FILES = Tweak.xm
LastTime_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
