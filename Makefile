TARGET    := build/PokeEdit
OUTPUT    := $(TARGET).nro
SRC_DIR   := source
SOURCES   := $(wildcard $(SRC_DIR)/*.cpp)
INCLUDES  := -I$(SRC_DIR) -Iimgui -Ilib -Inlohmann
ROMFS     := assets
ICON      := assets/icon.png

.PHONY: all clean ensure-imgui ensure-stbimg ensure-json ensure-release

# ==== Downloads für ImGui, stb_image, nlohmann/json ====
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

ensure-dirs:
	mkdir -p build

all: ensure-dirs ensure-imgui ensure-stbimg ensure-json $(OUTPUT) ensure-release

$(OUTPUT): $(SOURCES)
	$(CXX) $^ -o $@ $(INCLUDES) -lnx

clean:
	rm -rf build imgui lib nlohmann Release

# ----- Release Bundle: .nro + assets + i18n + config.json -----
ensure-release:
	mkdir -p Release
	cp $(OUTPUT) Release/ || { echo "NRO fehlt!"; exit 1; }
	cp -r assets Release/
	cp -r i18n Release/
	cp config.json Release/
	@echo "Release-Bundle fertig in ./Release/"
