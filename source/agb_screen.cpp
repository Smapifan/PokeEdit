#include "agb_screen.hpp"
#include <imgui.h>

bool DrawAGBScreen(const std::string& agbText, std::function<void()> onAccept) {
    static float scrollY = 0.0f;
    static bool canAccept = false;

    ImGui::SetNextWindowPos(ImVec2(80, 36), ImGuiCond_Always);
    ImGui::SetNextWindowSize(ImVec2(720, 500), ImGuiCond_Always);
    ImGui::Begin("AGB", nullptr, ImGuiWindowFlags_NoResize);

    ImGui::TextWrapped("AGB – Terms and Conditions");
    ImGui::Separator();

    // Scrollable region
    ImGui::BeginChild("AGBBody", ImVec2(0, 350), true, ImGuiWindowFlags_HorizontalScrollbar);
    ImGui::TextWrapped("%s", agbText.c_str());

    // Gamepad/Stick support: scroll (Switch: DPad, Stick L/R vertical)
    ImGuiIO& io = ImGui::GetIO();
    float padDelta = 0.0f;
    if (io.NavInputs[ImGuiNavInput_DpadDown] > 0.0f || io.NavInputs[ImGuiNavInput_LStickDown] > 0.0f)
        padDelta = 20.0f;
    if (io.NavInputs[ImGuiNavInput_DpadUp] > 0.0f || io.NavInputs[ImGuiNavInput_LStickUp] > 0.0f)
        padDelta = -20.0f;
    ImGui::SetScrollY(ImGui::GetScrollY() + padDelta);

    // "Ganz unten"-Erkennung
    float atEnd = ImGui::GetScrollY() + ImGui::GetWindowHeight();
    float all   = ImGui::GetScrollMaxY() + ImGui::GetWindowHeight();
    canAccept = (ImGui::GetScrollY() >= ImGui::GetScrollMaxY());

    ImGui::EndChild();

    // Button ausgegraut bis ganz unten gescrollt
    if (!canAccept)
        ImGui::BeginDisabled();
    bool accepted = ImGui::Button("Zustimmen / Accept", ImVec2(400,50));
    if (!canAccept)
        ImGui::EndDisabled();
    if (canAccept && accepted) {
        if(onAccept) onAccept();
        ImGui::End();
        return true; // accepted!
    }

    ImGui::End();
    return false;
}
