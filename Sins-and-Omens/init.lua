local translations = ModTextFileGetContent("data/translations/common.csv")
translations = translations .. [[
perk_greed,GREED,,,,,,,,,,,,,
perkdesc_greed,Gold to 1% HP per second,,,,,,,,,,,,,
perk_sloth,SLOTH,,,,,,,,,,,,,
perkdesc_sloth,Hold ALT to phase through walls and scout,,,,,,,,,,,,,
perk_wrath,WRATH,,,,,,,,,,,,,
perkdesc_wrath,Return all damage to your attackers - but rage leaves scars,,,,,,,,,,,,,
]]
translations = translations:gsub("\r", "")
ModTextFileSetContent("data/translations/common.csv", translations)

dofile("data/scripts/perks/perk_list.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/Sins-and-Omens/files/perks/perk_list.lua")

local PERK_MODULES = {
	dofile_once("mods/Sins-and-Omens/files/scripts/greed.lua"),
	dofile_once("mods/Sins-and-Omens/files/scripts/sloth.lua"),
	dofile_once("mods/Sins-and-Omens/files/scripts/wrath.lua"),
}

function OnPlayerSpawned(player_entity)
	for _, mod in ipairs(PERK_MODULES) do
		if mod.OnPlayerSpawned then mod.OnPlayerSpawned(player_entity) end
	end
end

function OnWorldPostUpdate()
	for _, mod in ipairs(PERK_MODULES) do
		if mod.OnWorldPostUpdate then mod.OnWorldPostUpdate() end
	end
end

function OnWorldPreUpdate() end
function OnModInit() end
function OnModPostInit() end
