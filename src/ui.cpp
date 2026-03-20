#include "ui.hpp"
#include "i18n.hpp"
#include <imgui.h>

extern I18n g_i18n; // Globale Übersetzungen (Stub, richtige Instanz in main!)

void draw_main_ui() {
    ImGui::Begin("PokeEdit - PKHeX Clone");

    if (!g_i18n.agbAccepted) {
        ImGui::Text("%s", g_i18n.t("AGB_TEXT").c_str());
        if (ImGui::Button(g_i18n.t("AGB_ACCEPT").c_str())) {
            g_i18n.agbAccepted = true; // Flag/Funktion anpassen
        }
    } else {
        ImGui::Text("Welches Spiel?");
        // Dummy: Spiel-Liste (richtige Logik analog Konsolenbeispiel)
        static const char* games[] = { "Let's Go, Eevee", "Let's Go, Pikachu" };
        static int currentGame = 0;
        ImGui::Combo("Game", &currentGame, games, IM_ARRAYSIZE(games));
        ImGui::Text("Sprites: ");
        std::string spritePath = "/switch/PokeEdit/assets/pokemon/133.png";
        ImTextureID spriteTex = loadSpriteTexture(spritePath.c_str());
        ImGui::Image(spriteTex, ImVec2(96,96));

        if (ImGui::Button(g_i18n.t("EDIT_SAVE").c_str())) {
            // Savegame-Parsing öffnen
        }
    }
    ImGui::End();
}
