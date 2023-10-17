set_languages("c++20") -- Because clangd isn't the world's biggest fan of "c++23"

add_rules("mode.debug", "mode.releasedbg", "mode.release") -- Default output types

-- SkyrimScripting package repository for packages such as skyrim-commonlib*
-- (and eventually will host all of the packages in this repository)
add_repositories("SkyrimScripting https://github.com/SkyrimScripting/Packages.git")

-- Mrowr's Library of C++ project, e.g. string_format, _Log_, function_pointer, void_pointer,
--                                     global_macro_functions, dependency_injection, ...
add_repositories("MrowrLib https://github.com/MrowrLib/Packages.git")

includes("*/*/xmake.lua") -- Include all the projects and their targets :)
