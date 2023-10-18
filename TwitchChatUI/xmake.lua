add_requires(
    "skyrim-commonlib",
    "websocketpp",
    "_Log_",
    "string_format"
)

target("SkyrimTwitchChatVR")
    add_files("*.cpp")
    add_includedirs(".")
    add_packages(
        "skyrim-commonlib",
        "websocketpp",
        "_Log_",
        "string_format"
    )
    add_rules("@skyrim-commonlib/plugin", {
        mods_folder = os.getenv("SKYRIM_SCRIPTING_MOD_FOLDERS")
    })
