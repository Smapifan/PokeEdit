TARGET    := build/PokeEdit
OUTPUT    := $(TARGET)
ROMFS     := assets
ICON      := assets/icon.png

.PHONY: all ensure-imgui ensure-stbimg ensure-json ensure-release clean

# Automatisch GUI/libs holen
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

SOURCES := $(shell find source -type f -name '*.cpp')
INCLUDES := -Isource -Iimgui -Ilib -Inlohmann

# Release-Ordner anlegen, NRO + Assets + config + i18n reinlegen
ensure-release:
	mkdir -p Release
	cp $(OUTPUT).nro Release/
	cp -r assets Release/
	cp -r i18n Release/
	cp config.json Release/

all: ensure-imgui ensure-stbimg ensure-json $(OUTPUT).nro ensure-release

# ... Rest wie gewohnt (libnx/switch_rules include, clean Targets usw.) ...
