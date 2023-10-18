#pragma once

#include <RE/Skyrim.h>  // IWYU pragma: keep

#include <format>  // IWYU pragma: keep

#include "Logging.h"

#define PrintConsole(...)                                                        \
    {                                                                            \
        logger::info(__VA_ARGS__);                                               \
        RE::ConsoleLog::GetSingleton()->Print(std::format(__VA_ARGS__).c_str()); \
    }
