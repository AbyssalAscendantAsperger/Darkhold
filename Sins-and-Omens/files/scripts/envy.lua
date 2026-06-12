local M = {}

local SCRIPT_PATH = "mods/Sins-and-Omens/files/scripts/envy_damage.lua"

local player_entity = nil
local check_timer = 0

local function GetPlayer()
	local players = EntityGetWithTag("player_unit")
	if players and #players > 0 then
		return players[1]
	end
	return nil
end

local function HasEnvyListener(ent)
	local comps = EntityGetComponentIncludingDisabled(ent, "LuaComponent")
	if comps then
		for _, comp in ipairs(comps) do
			local ok, src = pcall(ComponentGetValue2, comp, "script_damage_received")
			if ok and src == SCRIPT_PATH then
				return true
			end
		end
	end
	return false
end

local function AttachEnvyListener(ent)
	if HasEnvyListener(ent) then return end
	EntityAddComponent2(ent, "LuaComponent", {
		script_damage_received = SCRIPT_PATH,
		execute_every_n_frame = -1,
	})
end

function M.OnPlayerSpawned(entity)
	player_entity = entity
	check_timer = 0
end

function M.OnWorldPostUpdate()
	if not GameHasFlagRun("envy_perk") then return end

	check_timer = check_timer + 1
	if check_timer < 30 then return end
	check_timer = 0

	if player_entity == nil or not EntityGetIsAlive(player_entity) then
		player_entity = GetPlayer()
	end
	if player_entity == nil then return end

	AttachEnvyListener(player_entity)
end

return M
