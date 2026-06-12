local M = {}

local player_entity = nil

local TOUCH_RADIUS = 14
local CHARM_FRAMES = 600
local POTION_RADIUS = 12
local HP_PER_POTION = 1.0
local POLY_GRACE_FRAMES = 60

local POLY_MATERIALS = {
	"magic_liquid_polymorph",
	"magic_liquid_unstable_polymorph",
}

local poly_material_ids = nil
local charm_cooldown = {}
local poly_doom_frames = 0

local function GetPlayer()
	local players = EntityGetWithTag("player_unit")
	if players and #players > 0 then
		return players[1]
	end
	return nil
end

local function GetPolyMaterialIds()
	if poly_material_ids ~= nil then return poly_material_ids end
	poly_material_ids = {}
	for _, name in ipairs(POLY_MATERIALS) do
		local ok, mid = pcall(CellFactory_GetType, name)
		if ok and mid ~= nil and mid >= 0 then
			poly_material_ids[mid] = true
		end
	end
	return poly_material_ids
end

local function ShieldFromPolymorph(ent)
	local ok_n, n = pcall(GameGetGameEffectCount, ent, "PROTECTION_POLYMORPH")
	if ok_n and n ~= nil and n > 0 then
		return true
	end
	local ok, eff = pcall(GetGameEffectLoadTo, ent, "PROTECTION_POLYMORPH", false)
	if ok and eff ~= nil and eff ~= 0 then
		local comps = EntityGetComponentIncludingDisabled(eff, "GameEffectComponent")
		if comps then
			for _, c in ipairs(comps) do
				pcall(ComponentSetValue2, c, "frames", -1)
			end
		end
		return true
	end
	return false
end

local function IsCharmImmune(e)
	local ok, n = pcall(GameGetGameEffectCount, e, "PROTECTION_ALL")
	if ok and n ~= nil and n > 0 then return true end
	if EntityHasTag(e, "boss") or EntityHasTag(e, "polymorphable_NOT") then
		return true
	end
	return false
end

local function GetEnemyHP(e)
	local dmg = EntityGetFirstComponentIncludingDisabled(e, "DamageModelComponent")
	if dmg == nil then return nil end
	return tonumber(ComponentGetValue2(dmg, "hp"))
end

local function GetMyMaxHP(p)
	local dmg = EntityGetFirstComponentIncludingDisabled(p, "DamageModelComponent")
	if dmg == nil then return nil end
	return tonumber(ComponentGetValue2(dmg, "max_hp"))
end

local function CharmNearbyEnemies()
	local p = player_entity
	if p == nil then return end
	local px, py = EntityGetTransform(p)
	if px == nil then return end
	local my_max_hp = GetMyMaxHP(p)
	if my_max_hp == nil then return end
	local frame = GameGetFrameNum()

	local enemies = EntityGetInRadiusWithTag(px, py, TOUCH_RADIUS, "enemy") or {}
	for _, e in ipairs(enemies) do
		if EntityGetIsAlive(e)
			and not IsCharmImmune(e)
			and (charm_cooldown[e] == nil or frame > charm_cooldown[e]) then
			local ehp = GetEnemyHP(e)
			if ehp ~= nil and ehp < my_max_hp then
				local ok, eff = pcall(GetGameEffectLoadTo, e, "CHARM", true)
				if ok and eff ~= nil and eff ~= 0 then
					local comps = EntityGetComponentIncludingDisabled(eff, "GameEffectComponent")
					if comps then
						for _, c in ipairs(comps) do
							pcall(ComponentSetValue2, c, "frames", CHARM_FRAMES)
						end
					end
					charm_cooldown[e] = frame + CHARM_FRAMES
				end
			end
		end
	end

	if frame % 300 == 0 then
		for e, until_frame in pairs(charm_cooldown) do
			if frame > until_frame + 600 or not EntityGetIsAlive(e) then
				charm_cooldown[e] = nil
			end
		end
	end
end

local function DrinkPolymorphPotions()
	local p = player_entity
	if p == nil then return end
	local px, py = EntityGetTransform(p)
	if px == nil then return end
	local poly_ids = GetPolyMaterialIds()

	local items = EntityGetInRadiusWithTag(px, py, POTION_RADIUS, "item_pickup") or {}
	for _, item in ipairs(items) do
		if EntityGetIsAlive(item) then
			local ok, mat = pcall(GetMaterialInventoryMainMaterial, item, false)
			if ok and mat ~= nil and mat > 0 and poly_ids[mat] then
				local dmg = EntityGetFirstComponentIncludingDisabled(p, "DamageModelComponent")
				if dmg ~= nil then
					local hp = tonumber(ComponentGetValue2(dmg, "hp"))
					local max_hp = tonumber(ComponentGetValue2(dmg, "max_hp"))
					if hp ~= nil and max_hp ~= nil then
						local new_hp = hp + HP_PER_POTION
						if new_hp > max_hp then new_hp = max_hp end
						ComponentSetValue2(dmg, "hp", new_hp)
					end
				end
				EntityKill(item)
				GamePrintImportant("LUST CONSUMES", "")
			end
		end
	end
end

local function IsPolymorphed()
	local current = GetPlayer()
	if current ~= nil then
		return false, current
	end
	for _, tag in ipairs({ "polymorphed_player", "polymorphed" }) do
		local ents = EntityGetWithTag(tag) or {}
		for _, e in ipairs(ents) do
			if EntityGetIsAlive(e) and EntityHasTag(e, "polymorphed_player") then
				return true, e
			end
		end
	end
	return false, nil
end

local function ExecutePolymorphDoom(poly_ent)
	local dmg = EntityGetFirstComponentIncludingDisabled(poly_ent, "DamageModelComponent")
	if dmg ~= nil then
		ComponentSetValue2(dmg, "hp", 0.001)
	end
	EntityInflictDamage(poly_ent, 1000000, "DAMAGE_CURSE", "lust", "NONE", 0, 0, poly_ent)
end

function M.OnPlayerSpawned(entity)
	player_entity = entity
	charm_cooldown = {}
	poly_doom_frames = 0
end

function M.OnWorldPostUpdate()
	if not GameHasFlagRun("lust_perk") then return end

	local is_poly, ent = IsPolymorphed()

	if is_poly and ent ~= nil then
		poly_doom_frames = poly_doom_frames + 1
		if poly_doom_frames >= POLY_GRACE_FRAMES then
			ExecutePolymorphDoom(ent)
			poly_doom_frames = 0
		end
		return
	end

	poly_doom_frames = 0
	if ent == nil then return end
	player_entity = ent

	ShieldFromPolymorph(player_entity)
	CharmNearbyEnemies()
	DrinkPolymorphPotions()
end

return M