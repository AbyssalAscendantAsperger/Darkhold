local M = {}

local player_entity = nil

local STATE_GROUNDED = 0
local STATE_FLYING = 1

local state = STATE_GROUNDED
local hp_before_flight = nil
local debt = 0
local prev_fly_time = nil
local ground_frames = 0
local GROUND_FRAMES_REQUIRED = 5

local function GetPlayer()
	local players = EntityGetWithTag("player_unit")
	if players and #players > 0 then
		return players[1]
	end
	return nil
end

local function GetComps(ent)
	local cdata = EntityGetFirstComponentIncludingDisabled(ent, "CharacterDataComponent")
	local dmg = EntityGetFirstComponentIncludingDisabled(ent, "DamageModelComponent")
	return cdata, dmg
end

local function SaveState()
	GlobalsSetValue("SINS_OMENS_PRIDE_STATE", tostring(state))
	GlobalsSetValue("SINS_OMENS_PRIDE_HP", tostring(hp_before_flight or -1))
	GlobalsSetValue("SINS_OMENS_PRIDE_DEBT", tostring(debt))
end

local function LoadState()
	state = tonumber(GlobalsGetValue("SINS_OMENS_PRIDE_STATE", "0")) or STATE_GROUNDED
	local hp = tonumber(GlobalsGetValue("SINS_OMENS_PRIDE_HP", "-1")) or -1
	hp_before_flight = (hp >= 0) and hp or nil
	debt = tonumber(GlobalsGetValue("SINS_OMENS_PRIDE_DEBT", "0")) or 0
end

local function ResetToGrounded()
	state = STATE_GROUNDED
	hp_before_flight = nil
	debt = 0
	prev_fly_time = nil
	ground_frames = 0
	SaveState()
end

function M.OnPlayerSpawned(entity)
	if player_entity ~= nil and entity ~= player_entity then
		ResetToGrounded()
	end
	player_entity = entity
	LoadState()
end

function M.OnWorldPostUpdate()
	if not GameHasFlagRun("pride_perk") then return end

	local current = GetPlayer()
	if current == nil then return end
	if player_entity ~= nil and current ~= player_entity and state == STATE_FLYING then
		ResetToGrounded()
	end
	player_entity = current

	local cdata, dmg = GetComps(player_entity)
	if cdata == nil or dmg == nil then return end

	local ok_f, fly_time = pcall(ComponentGetValue2, cdata, "mFlyingTimeLeft")
	local ok_g, on_ground = pcall(ComponentGetValue2, cdata, "is_on_ground")
	if not ok_f or not ok_g or fly_time == nil or on_ground == nil then return end

	local hp = tonumber(ComponentGetValue2(dmg, "hp"))
	local max_hp = tonumber(ComponentGetValue2(dmg, "max_hp"))
	if hp == nil or max_hp == nil then return end

	if state == STATE_GROUNDED then
		local burning_levi = (prev_fly_time ~= nil) and (fly_time < prev_fly_time - 0.0001)
		if burning_levi and not on_ground then
			state = STATE_FLYING
			hp_before_flight = hp
			debt = 0
			ground_frames = 0
			ComponentSetValue2(dmg, "hp", max_hp)
			SaveState()
		end
	elseif state == STATE_FLYING then
		if hp < max_hp then
			debt = debt + (max_hp - hp)
			ComponentSetValue2(dmg, "hp", max_hp)
			SaveState()
		end

		if on_ground then
			ground_frames = ground_frames + 1
		else
			ground_frames = 0
		end

		if ground_frames >= GROUND_FRAMES_REQUIRED then
			local final_hp = (hp_before_flight or max_hp) - debt
			if final_hp <= 0 then
				ComponentSetValue2(dmg, "hp", 0.001)
				EntityInflictDamage(player_entity, 0.002, "DAMAGE_CURSE", "pride", "NONE", 0, 0, player_entity)
			else
				ComponentSetValue2(dmg, "hp", final_hp)
			end
			ResetToGrounded()
		end
	end

	prev_fly_time = fly_time
end

return M
