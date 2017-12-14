THEOS_DEVICE_IP = 192.168.2.9

include $(THEOS)/makefiles/common.mk

SRC = $(wildcard src/*.m)

TWEAK_NAME = WeChatRedEnvelopesHelper
WeChatRedEnvelopesHelper_FILES = $(wildcard src/*.m) src/Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WeChat"


