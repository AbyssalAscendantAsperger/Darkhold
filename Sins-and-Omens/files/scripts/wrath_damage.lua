function damage_received(damage, desc, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if not GameHasFlagRun("wrath_perk") then return end
	if damage == nil or damage <= 0 then return end
	if desc ~= nil and string.find(tostring(desc), "wrath") ~= nil then return end

	local player = GetUpdatedEntityID()
	local attacker = entity_thats_responsible
	if attacker == nil or attacker == 0 or attacker == player then return end
	if not EntityGetIsAlive(attacker) then return end

	local pdm = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
	if pdm == nil then return end
	local php = ComponentGetValue2(pdm, "hp")
	if php == nil or php <= 1.0 then return end

	local stacks = tonumber(GlobalsGetValue("SINS_OMENS_WRATH_STACKS", "0")) or 0
	if stacks < 1 then stacks = 1 end
	if stacks > 3 then stacks = 3 end

	local adm = EntityGetFirstComponentIncludingDisabled(attacker, "DamageModelComponent")
	if adm ~= nil then
		local ahp = ComponentGetValue2(adm, "hp")
		if ahp ~= nil then
			local reflected = damage * stacks
			local new_hp = ahp - reflected
			if new_hp <= 0 then
				ComponentSetValue2(adm, "hp", 0.001)
				EntityInflictDamage(attacker, 0.002, "DAMAGE_CURSE", "wrath", "NONE", 0, 0, player)
			else
				ComponentSetValue2(adm, "hp", new_hp)
			end
		end
	end

	local chance = 0.10 + 0.30 * (stacks - 1)
	if chance > 0.70 then chance = 0.70 end
	local threshold = math.floor(chance * 100 + 0.5)
	local roll
	if math ~= nil and math.random ~= nil then
		roll = math.random(1, 100)
	else
		SetRandomSeed(GameGetFrameNum() * 7919 + attacker, player * 131 + GameGetFrameNum())
		Random(1, 100)
		Random(1, 100)
		roll = Random(1, 100)
	end
	if roll <= threshold then
		local max_hp = ComponentGetValue2(pdm, "max_hp")
		if max_hp ~= nil then
			local burned = max_hp - damage
			if burned < 0.04 then burned = 0.04 end
			ComponentSetValue2(pdm, "max_hp", burned)
			local hp_now = ComponentGetValue2(pdm, "hp")
			if hp_now ~= nil and hp_now > burned then
				ComponentSetValue2(pdm, "hp", burned)
			end
			GamePrintImportant("WRATH SCARS YOU", "")
		end
	end
end
