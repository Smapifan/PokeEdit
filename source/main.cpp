#include <switch.h>
#include <imgui.h>
#include "agb_screen.hpp"
#include "i18n.hpp"
#include <nlohmann/json.hpp>
#include <fstream>

const std::string LANGPATH = "i18n/";
const std::string CFGPATH = "config.json";

struct AppConfig {
    bool agbAccepted = false;
    std::string language = "default";
    bool load() {
        std::ifstream f(CFGPATH);
        if (!f) return false;
        nlohmann::json j; f >> j;
        agbAccepted = j.value("agbAccepted", false);
        language = j.value("language", "default");
        return true;
    }
    void save() const {
        nlohmann::json j;
        j["agbAccepted"] = agbAccepted;
        j["language"] = language;
        std::ofstream f(CFGPATH);
        f << j.dump(4);
    }
};
AppConfig g_appcfg;

int main(int argc, char* argv[]) {
    consoleInit(NULL);
    g_appcfg.load();

    // (ImGui Init siehe ImGui_NX Beispiel/Framework!)
    I18n i18n;
    i18n.load(LANGPATH, g_appcfg.language);

    bool agbReady = g_appcfg.agbAccepted;
    while (appletMainLoop()) {
        hidScanInput();
        ImGui_NewFrame();
        if(!agbReady) {
            bool accepted = DrawAGBScreen(i18n.t("AGB_BODY"), [&](){
                g_appcfg.agbAccepted = true; g_appcfg.save();
                agbReady = true;
            });
            // Eventuell ImGui::EndFrame usw. falls Framework gebraucht
            if(!accepted) ImGui_Render();
            else break;
        } else {
            // Hier später: Hauptfenster (Box/Party/Editor usw.)
            ImGui::Text("Demo: After the terms and conditions comes the UI...");
            ImGui_Render();
        }
        if (hidKeysDown(CONTROLLER_P1_AUTO) & KEY_PLUS) break;
    }
    ImGui_Shutdown();
    consoleExit(NULL);
    return 0;
}
