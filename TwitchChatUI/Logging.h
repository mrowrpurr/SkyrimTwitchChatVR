#pragma once

#include <SKSE/SKSE.h>

// This is a snippet you can put at the top of all of your SKSE plugins!

#include <spdlog/sinks/basic_file_sink.h>

namespace logger = SKSE::log;

#ifndef _Log_
    #define _Log_(...) logger::info(__VA_ARGS__)
#endif

void SetupLog(const std::string& pluginName) {
    auto logsFolder = SKSE::log::log_directory();
    if (!logsFolder) SKSE::stl::report_and_fail("SKSE log_directory not provided, logs disabled.");
    auto logFilePath = *logsFolder / std::format("{}.log", pluginName);
    auto fileLoggerPtr =
        std::make_shared<spdlog::sinks::basic_file_sink_mt>(logFilePath.string(), true);
    auto loggerPtr = std::make_shared<spdlog::logger>("log", std::move(fileLoggerPtr));
    spdlog::set_default_logger(std::move(loggerPtr));
    spdlog::set_level(spdlog::level::trace);
    spdlog::flush_on(spdlog::level::trace);
    spdlog::set_pattern("%v");
}

// Then just call SetupLog() in your SKSE plugin initialization
//
// ^---- don't forget to do this or your logs won't work :)