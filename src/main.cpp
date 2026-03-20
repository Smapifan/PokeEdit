#include <switch.h>
#include "ui.hpp"

int main(int argc, char* argv[]) {
    // Switch-Framebuffer/ImGui initialisieren
    ImGui_Initialize();
    while (appletMainLoop()) {
        hidScanInput();
        u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
        if (kDown & KEY_PLUS) break;

        ImGui_NewFrame();
        draw_main_ui(); // Siehe ui.cpp
        ImGui_Render();
    }
    ImGui_Shutdown();
    return 0;
}
