#pragma once
#include <string>
#include <nlohmann/json.hpp>
struct I18n {
    nlohmann::json langData;
    nlohmann::json fallback;
    std::string language   = "default";
    bool load(const std::string& langpath, const std::string& lang) {
        language = lang;
        std::ifstream f1(langpath + lang + ".json"), f2(langpath + "default.json");
        if (f1) f1 >> langData;
        if (f2) f2 >> fallback;
        return langData.size() || fallback.size();
    }
    std::string t(const std::string& key) const {
        if (langData.contains(key)) return langData[key];
        if (fallback.contains(key)) return fallback[key];
        return key;
    }
};
