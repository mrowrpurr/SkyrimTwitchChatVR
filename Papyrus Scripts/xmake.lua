local mod_name    = "SkyrimTwitchChatVR"
local mod_folders = os.getenv("SKYRIM_SCRIPTING_MOD_FOLDERS")

target("Build Papyrus Scripts")
    set_kind("phony")

    before_build(function (target)
        print("Building Papyrus Scripts")
        local skyrim_with_ck = os.getenv("SKYRIM_WITH_CK")
        if not skyrim_with_ck then
            print("SKYRIM_WITH_CK environment variable not set")
            return
        end
        os.exec("pyro -i Papyrus.ppj --game-path \"" .. skyrim_with_ck .. "\"")
    end)

target("Deploy Papyrus Scripts")
    set_kind("phony")

    add_deps("Build Papyrus Scripts")

    after_build(function (target)
        local compiled_scripts_folder = ".CompiledScripts"
        local folder_paths = {}
        for _, folder in ipairs(mod_folders:split(";")) do
            if item ~= "" then
                folder_paths[folder] = true
            end
        end
        for mods_folder_path in pairs(folder_paths) do
            local mod_folder = path.join(mods_folder_path, mod_name)
            print("Copying compiled scripts to " .. mod_folder)
            os.mkdir(path.join(mod_folder, "Scripts", "Source"))
            os.mkdir(path.join(mod_folder, "Scripts", "Bindings"))
            os.cp(path.join(compiled_scripts_folder, "*.pex"), path.join(mod_folder, "Scripts"))
            os.cp(path.join("*", "*.psc"), path.join(mod_folder, "Scripts", "Source"))
            os.cp(path.join("*", "Bindings", "*"), path.join(mod_folder, "Scripts", "Bindings"))
        end
    end)
