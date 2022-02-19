export DEBUG = 0
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:12.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Aeaea

Aeaea_FILES = Tweak.xm
Aeaea_PRIVATE_FRAMEWORKS = BulletinBoard
Aeaea_CFLAGS = -fobjc-arc -Wno-unguarded-availability-new # since can't use @available on Linux

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += AeaeaPrefs

include $(THEOS_MAKE_PATH)/aggregate.mk
