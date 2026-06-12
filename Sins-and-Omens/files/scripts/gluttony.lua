local M = {}

local DAMAGE_TYPES = {
	"melee", "projectile", "explosion", "electricity",
	"fire", "ice", "slice", "physics_hit", "poison", "radioactive", "drill",
}

local MAX_GAIN_PER_TYPE = 1.2
local MAX_LOSS_PER_TYPE = 0.4
local GUI_DURATION_FRAMES = 180

local player_entity = nil
local tracked = {}
local scan_timer = 0
local SCAN_INTERVAL = 12
local SCAN_RADIUS = 320

local gui = nil
local gui_until_frame = -1
local gui_lines = {}

local function GetPlayer()
	local players = EntityGetWithTag("player_unit")
	if players and #players > 0 then
		return players[1]
	end
	return nil
end

local function GetMulti(ent, dtype)
	local dmg = EntityGetFirstComponentIncludingDisabled(ent, "DamageModelComponent")
	if dmg == nil then return nil end
	local ok, val = pcall(ComponentObjectGetValue2, dmg, "damage_multipliers", dtype)
	if not ok then return nil end
	return tonumber(val)
end

local function SetMulti(ent, dtype, value)
	local dmg = EntityGetFirstComponentIncludingDisabled(ent, "DamageModelComponent")
	if dmg == nil then return false end
	local ok = pcall(ComponentObjectSetValue2, dmg, "damage_multipliers", dtype, value)
	return ok
end

local function SnapshotEnemy(enemy)
	local snap = {}
	local any = false
	for _, dtype in ipairs(DAMAGE_TYPES) do
		local v = GetMulti(enemy, dtype)
		if v ~= nil then
			snap[dtype] = v
			any = true
		end
	end
	return any and snap or nil
end

local function Devour(snap)
	if player_entity == nil then return end
	gui_lines = {}
	for _, dtype in ipairs(DAMAGE_TYPES) do
		local enemy_mult = snap[dtype]
		local mine = GetMulti(player_entity, dtype)
		if enemy_mult ~= nil and mine ~= nil then
			if enemy_mult > 0.0001 and math.abs(enemy_mult - mine) > 0.0001 then
				local delta
				if enemy_mult > mine then
					delta = math.min(enemy_mult - mine, MAX_GAIN_PER_TYPE)
				else
					delta = -math.min(mine - enemy_mult, MAX_LOSS_PER_TYPE)
				end
				local new_val = mine + delta
				if new_val < 0.05 then new_val = 0.05 end
				if SetMulti(player_entity, dtype, new_val) then
					table.insert(gui_lines, {
						dtype = dtype,
						old = mine,
						new = new_val,
						delta = delta,
					})
				end
			end
		end
	end
	if #gui_lines > 0 then
		gui_until_frame = GameGetFrameNum() + GUI_DURATION_FRAMES
		GamePrintImportant("GLUTTONY FEASTS", "")
	end
end

local function ScanEnemies()
	if player_entity == nil then return end
	local px, py = EntityGetTransform(player_entity)
	if px == nil then return end

	local now = {}
	local enemies = EntityGetInRadiusWithTag(px, py, SCAN_RADIUS, "enemy") or {}
	for _, e in ipairs(enemies) do
		if EntityGetIsAlive(e) then
			now[e] = true
			if tracked[e] == nil then
				local snap = SnapshotEnemy(e)
				if snap ~= nil then
					tracked[e] = { snap = snap, last_seen = GameGetFrameNum() }
				end
			else
				tracked[e].last_seen = GameGetFrameNum()
			end
		end
	end

	local frame = GameGetFrameNum()
	for e, info in pairs(tracked) do
		if not now[e] then
			local alive = EntityGetIsAlive(e)
			if not alive then
				Devour(info.snap)
				tracked[e] = nil
			elseif frame - info.last_seen > 600 then
				tracked[e] = nil
			end
		end
	end
end

local function FacingRight()
	if player_entity == nil then return true end
	local controls = EntityGetFirstComponentIncludingDisabled(player_entity, "ControlsComponent")
	if controls ~= nil then
		local ok, aim_x = pcall(ComponentGetValue2, controls, "mAimingVector")
		if ok and aim_x ~= nil then
			return aim_x >= 0
		end
	end
	local _, _, _, sx = EntityGetTransform(player_entity)
	if sx == nil then return true end
	return sx >= 0
end

local function DrawGui()
	if GameGetFrameNum() > gui_until_frame then return end
	if #gui_lines == 0 then return end

	if gui == nil then
		gui = GuiCreate()
	end
	GuiStartFrame(gui)

	local screen_w, screen_h = GuiGetScreenDimensions(gui)
	local panel_w = 110
	local x
	if FacingRight() then
		x = 12
	else
		x = screen_w - panel_w - 12
	end
	local y = screen_h * 0.32

	local id = 44000
	GuiText(gui, x, y, "GLUTTONY DEVOURS:")
	y = y + 11
	for _, line in ipairs(gui_lines) do
		id = id + 1
		local sign = line.delta >= 0 and "+" or ""
		GuiText(gui, x, y, string.format("%s: %.2f (%s%.2f)", line.dtype, line.new, sign, line.delta))
		y = y + 9
	end
end

function M.OnPlayerSpawned(entity)
	player_entity = entity
	tracked = {}
end

function M.OnWorldPostUpdate()
	if not GameHasFlagRun("gluttony_perk") then
		return
	end

	if player_entity == nil or not EntityGetIsAlive(player_entity) then
		player_entity = GetPlayer()
		if player_entity == nil then return end
	end

	scan_timer = scan_timer + 1
	if scan_timer >= SCAN_INTERVAL then
		scan_timer = 0
		ScanEnemies()
	end

	DrawGui()
end

return M
