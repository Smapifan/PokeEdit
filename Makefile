TARGET  := PokeEdit
SRC_DIR := src
OBJ_DIR := build
BUILD   := $(OBJ_DIR)
INCLUDE := include imgui lib
CXXFLAGS := -std=gnu++17 -O2 $(foreach D,$(INCLUDE),-I$(D))
OBJS    := $(addprefix $(OBJ_DIR)/,main.o ui.o)
LIBS    := -lnx

JSON_HPP := nlohmann/json.hpp
STB := lib/stb_image.h

.PHONY: all clean imgui stb

all: $(TARGET).nro

# Auto-Download ImGui + stb_image
imgui:
	mkdir -p include/imgui
	git clone --depth=1 https://github.com/ocornut/imgui include/imgui

$(STB):
	curl -L -o $@ https://raw.githubusercontent.com/nothings/stb/master/stb_image.h

$(OBJ_DIR)/main.o: src/main.cpp imgui $(STB) $(JSON_HPP)
	mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR)/ui.o: src/ui.cpp src/ui.hpp
	mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET).nro: $(OBJS)
	nxlink -o $@ $^ $(LIBS)

clean:
	rm -rf $(OBJ_DIR) $(TARGET).nro
