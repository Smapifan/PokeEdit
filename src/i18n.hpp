#pragma once
#include <string>
struct I18n {
    bool agbAccepted = false;
    std::string t(const std::string& key) const;
};
