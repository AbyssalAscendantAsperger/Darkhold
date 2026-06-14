local translations = ModTextFileGetContent("data/translations/common.csv")
translations = translations .. [[
perk_greed,GREED,,,,,,,,,,,,,
perkdesc_greed,Gold to 1% HP per second,,,,,,,,,,,,,
perk_sloth,SLOTH,,,,,,,,,,,,,
perkdesc_sloth,Hold ALT to phase through walls and scout,,,,,,,,,,,,,
perk_wrath,WRATH,,,,,,,,,,,,,
perkdesc_wrath,Return all damage to your attackers - but rage leaves scars,,,,,,,,,,,,,
perk_pride,PRIDE,,,,,,,,,,,,,
perkdesc_pride,Untouchable in the air - but the ground remembers every debt,,,,,,,,,,,,,
perk_gluttony,GLUTTONY,,,,,,,,,,,,,
perkdesc_gluttony,Devour the resistances of the slain,,,,,,,,,,,,,
perk_envy,ENVY,,,,,,,,,,,,,
perkdesc_envy,Suffer before the strong - thrive against the weak,,,,,,,,,,,,,
perk_lust,LUST,,,,,,,,,,,,,
perkdesc_lust,Your touch seduces - polymorph cannot claim you,,,,,,,,,,,,,
]]
translations = translations:gsub("\r", "")
ModTextFileSetContent("data/translations/common.csv", translations)

dofile("data/scripts/perks/perk_list.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/Sins-and-Omens/files/perks/perk_list.lua")

local PERK_MODULES = {
	dofile_once("mods/Sins-and-Omens/files/scripts/greed.lua"),
	dofile_once("mods/Sins-and-Omens/files/scripts/sloth.lua"),
	dofile_once("mods/Sins-and-Omens/files/scripts/wrath.lua"),
	dofile_once("mods/Sins-and-Omens/files/scripts/pride.lua"),
	dofile_once("mods/Sins-and-Omens/files/scripts/gluttony.lua"),
	dofile_once("mods/Sins-and-Omens/files/scripts/envy.lua"),
	dofile_once("mods/Sins-and-Omens/files/scripts/lust.lua"),
}

local MOD_ID = "Sins-and-Omens"

local SINS = {
	{ id = "greed",    max_stacks = 10 },
	{ id = "sloth",    max_stacks = 1  },
	{ id = "wrath",    max_stacks = 3  },
	{ id = "pride",    max_stacks = 1  },
	{ id = "gluttony", max_stacks = 1  },
	{ id = "envy",     max_stacks = 4  },
	{ id = "lust",     max_stacks = 1  },
}

local function get_setting(sin_id)
	local key = MOD_ID .. "." .. sin_id
	local val = ModSettingGetNextValue(key)
	if val == nil then
		val = ModSettingGet(key)
	end
	return tonumber(val) or 0
end

local perks_applied = false

local function ApplySettingsPerks(player_entity)
	if perks_applied then return end
	perks_applied = true

	if not player_entity or not EntityGetIsAlive(player_entity) then return end

	local x, y = EntityGetTransform(player_entity)
	if not x or not y then return end

	dofile_once("data/scripts/perks/perk.lua")
	dofile_once("data/scripts/perks/perk_list.lua")

	for _, sin in ipairs(SINS) do
		local val = get_setting(sin.id)
		if val > 0 then
			for i = 1, math.floor(val) do
				local perk_entity = perk_spawn(x, y, sin.id)
				if perk_entity and perk_entity ~= 0 then
					perk_pickup(perk_entity, player_entity, EntityGetName(perk_entity), false, false)
				end
			end
		end
	end
end

function OnPlayerSpawned(player_entity)
	ApplySettingsPerks(player_entity)

	for _, mod in ipairs(PERK_MODULES) do
		if mod.OnPlayerSpawned then
			mod.OnPlayerSpawned(player_entity)
		end
	end
end

function OnWorldPostUpdate()
	if not perks_applied then
		local players = EntityGetWithTag("player_unit")
		if players and #players > 0 and EntityGetIsAlive(players[1]) then
			ApplySettingsPerks(players[1])
		end
	end

	for _, mod in ipairs(PERK_MODULES) do
		if mod.OnWorldPostUpdate then
			mod.OnWorldPostUpdate()
		end
	end
end

function OnWorldPreUpdate() end
function OnModInit() end
function OnModPostInit() end
