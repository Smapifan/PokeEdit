ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

CFLAGS   += -Isource -Iimgui -Ilib -Inlohmann
CXXFLAGS += -Isource -Iimgui -Ilib -Inlohmann

include $(DEVKITPRO)/libnx/switch_rules

TARGET      := build/PokeEdit
APP_TITLE   := PokeEdit
APP_AUTHOR  := Smapifan
APP_VERSION := 1.0.0
ROMFS       := assets
ICON        := assets/icon.png

.PHONY: all clean ensure-imgui ensure-stbimg ensure-json ensure-release

# ==== Dynamische Fetch-Regeln für ImGui, stb_image, nlohmann/json ====
ensure-imgui:
	@if [ ! -f imgui/imgui.h ]; then \
		echo "Cloning ImGui ..."; \
		git clone --depth=1 https://github.com/ocornut/imgui.git imgui; \
	fi

ensure-stbimg:
	@if [ ! -f lib/stb_image.h ]; then \
		echo "Downloading stb_image.h ..."; \
		mkdir -p lib; \
		curl -L -o lib/stb_image.h https://raw.githubusercontent.com/nothings/stb/master/stb_image.h; \
	fi

ensure-json:
	@if [ ! -f nlohmann/json.hpp ]; then \
		echo "Downloading nlohmann/json.hpp ..."; \
		mkdir -p nlohmann; \
		curl -L -o nlohmann/json.hpp https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp; \
	fi

all: ensure-imgui ensure-stbimg ensure-json $(TARGET).nro ensure-release

# ----- Release Bundle: NRO + assets + i18n + config.json -----
ensure-release:
	mkdir -p Release
	cp build/PokeEdit.nro Release/
	cp -r assets Release/
	cp -r i18n Release/
	cp config.json Release/
	@echo "Release-Bundle fertig: Release/"

clean:
	rm -rf build imgui lib nlohmann Release
