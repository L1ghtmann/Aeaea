DEBUG=0
ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Aeaea

Aeaea_FILES = Tweak.xm
Aeaea_PRIVATE_FRAMEWORKS = BulletinBoard
Aeaea_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += aeaeaprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
