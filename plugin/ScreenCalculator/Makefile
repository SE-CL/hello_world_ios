ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ScreenCalculator
ScreenCalculator_FILES = Tweak.xm
ScreenCalculator_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
