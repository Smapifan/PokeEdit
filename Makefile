TARGET       := build/PokeEdit
OUTPUT_NRO   := $(TARGET).nro
SRC_DIR      := source
SOURCES      := $(wildcard $(SRC_DIR)/*.cpp)
INCLUDES     := -I$(SRC_DIR) -Iimgui -Ilib -Inlohmann
ROMFS        := assets
ICON         := assets/icon.png

.PHONY: all clean ensure-imgui ensure-stbimg ensure-json release-dirs release-bundle

all: release-bundle

# == Dynamic Includes: Wie bei PKMswitch nur frisch beim Build! ==
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

release-dirs:
	mkdir -p build
	mkdir -p Release

# == Build-Rule ==
$(OUTPUT_NRO): $(SOURCES) | ensure-imgui ensure-stbimg ensure-json release-dirs
	$(CXX) $(SOURCES) -o $(OUTPUT_NRO) $(INCLUDES) -lnx

# == Bundle: .nro, assets, i18n und config.json ==
release-bundle: $(OUTPUT_NRO)
	cp $(OUTPUT_NRO) Release/ || { echo "PokeEdit.nro fehlt!"; exit 1; }
	cp -r assets Release/
	cp -r i18n Release/
	cp config.json Release/
	@echo "Release-Bundle gebaut: Release/"

clean:
	rm -rf build imgui lib nlohmann Release
