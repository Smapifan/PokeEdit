ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

TARGET := build/PokeEdit
APP_TITLE := PokeEdit
APP_AUTHOR := Smapifan
APP_VERSION := 1.0.0
ROMFS := assets
ICON := assets/icon.png

# Falls du extra Include-Pfade brauchst:
CFLAGS   += -Isource -Iimgui
CXXFLAGS += -Isource -Iimgui

# Standard (kein eigenes OFILES oder SOURCES nötig!)
# Die switch_rules von devkitPro übernehmen alles

include $(DEVKITPRO)/libnx/switch_rules

.PHONY: clean
clean:
	rm -rf build imgui *.o *.d
