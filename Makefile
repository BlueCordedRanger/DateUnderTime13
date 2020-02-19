THEOS_DEVICE_IP = 192.168.1.7
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DateUnderTime
DateUnderTime_FILES = DateUnderTime.xm
DateUnderTime_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
