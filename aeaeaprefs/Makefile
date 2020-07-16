include $(THEOS)/makefiles/common.mk
ARCHS = arm64 arm64e
BUNDLE_NAME = AeaeaPrefs

AeaeaPrefs_FILES = $(wildcard *.m)
AeaeaPrefs_INSTALL_PATH = /Library/PreferenceBundles
AeaeaPrefs_FRAMEWORKS = UIKit
AeaeaPrefs_PRIVATE_FRAMEWORKS = Preferences
AeaeaPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AeaeaPrefs.plist$(ECHO_END)
