TARGET := PokeEdit
SRC := src
OBJ := build
INCLUDE := include imgui_nx
CXXFLAGS := -std=gnu++17 -O2 $(foreach D,$(INCLUDE),-I$(D))
OBJS := $(OBJ)/main.o $(OBJ)/agb_screen.o
LIBS := -lnx

# ImGui-NX
IMGUI_NX_URL := https://github.com/crocodile2020/imgui_nx.git
IMGUI_DIR := imgui_nx

# nlohmann/json
JSON_HPP := nlohmann/json.hpp

$(IMGUI_DIR):
	git clone --depth=1 $(IMGUI_NX_URL) $(IMGUI_DIR)

$(JSON_HPP):
	mkdir -p nlohmann
	curl -L -o $(JSON_HPP) https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp

.PHONY: all clean

all: $(TARGET).nro

$(OBJ)/main.o: src/main.cpp src/agb_screen.hpp src/i18n.hpp $(JSON_HPP) | $(OBJ)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ)/agb_screen.o: src/agb_screen.cpp src/agb_screen.hpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET).nro: $(IMGUI_DIR) $(OBJS)
	nxlink -o $@ $(OBJS) $(LIBS)

$(OBJ):
	mkdir -p $(OBJ)

clean:
	rm -rf $(OBJ) $(TARGET).nro $(IMGUI_DIR) nlohmann
