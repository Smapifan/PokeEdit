#pragma once
#include <string>
#include <functional>

bool DrawAGBScreen(const std::string& agbText, std::function<void()> onAccept);
