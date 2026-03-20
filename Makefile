ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

include $(DEVKITPRO)/libnx/switch_rules

TARGET    := build/PokeEdit
APP_TITLE := PokeEdit
APP_AUTHOR := Smapifan
APP_VERSION := 1.0.0
ROMFS     := assets
ICON      := assets/icon.png

# Includes fetchen (wie gehabt!)
ensure-imgui:
	@if [ ! -f imgui/imgui.h ]; then \
		echo "Cloning ImGui ..."; \
		git clone --depth=1 https://github.com/ocornut/imgui.git imgui; \
	fi
ensure-stbimg:
	@if [ ! -f lib/stb_image.h ]; then \
		mkdir -p lib; \
		curl -L -o lib/stb_image.h https://raw.githubusercontent.com/nothings/stb/master/stb_image.h; \
	fi
ensure-json:
	@if [ ! -f nlohmann/json.hpp ]; then \
		mkdir -p nlohmann; \
		curl -L -o nlohmann/json.hpp https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp; \
	fi

all: ensure-imgui ensure-stbimg ensure-json $(TARGET).nro ensure-release

# Release Bundle: wie gehabt (NRO + assets + i18n + config.json)
ensure-release:
	mkdir -p Release
	cp build/PokeEdit.nro Release/
	cp -r assets Release/
	cp -r i18n Release/
	cp config.json Release/
