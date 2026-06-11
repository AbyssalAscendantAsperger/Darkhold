pushd ..
tools_modding\luacheck . --exclude-files **/_legacy/*.lua **/_legacy/lua_tests/*.lua --config tools_modding/luacheck_config.lua -quiet --allow-defined --no-max-line-length --ignore 131 211 212 213 311 542 611 612 614 --globals print_error dofile_once async wait GameRegisterStatusEffect Reflection_RegisterProjectile RegisterPerk RegisterGun BIOME_NAME
popd