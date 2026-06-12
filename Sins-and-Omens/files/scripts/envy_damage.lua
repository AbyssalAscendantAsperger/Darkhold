function damage_received(damage, desc, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if not GameHasFlagRun("envy_perk") then return end
	if damage == nil or damage <= 0 then return end
	local d = tostring(desc or "")
	if string.find(d, "envy") or string.find(d, "wrath") or string.find(d, "pride") then return end

	local player = GetUpdatedEntityID()
	local attacker = entity_thats_responsible
	if attacker == nil or attacker == 0 or attacker == player then return end
	if not EntityGetIsAlive(attacker) then return end

	local pdm = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
	if pdm == nil then return end
	local php = tonumber(ComponentGetValue2(pdm, "hp"))
	local pmax = tonumber(ComponentGetValue2(pdm, "max_hp"))
	if php == nil or pmax == nil then return end

	local adm = EntityGetFirstComponentIncludingDisabled(attacker, "DamageModelComponent")
	if adm == nil then return end
	local ahp = tonumber(ComponentGetValue2(adm, "hp"))
	if ahp == nil then return end

	local stacks = tonumber(GlobalsGetValue("SINS_OMENS_ENVY_STACKS", "0")) or 0
	if stacks < 1 then stacks = 1 end
	if stacks > 4 then stacks = 4 end
	local pct = 0.20 * stacks

	if ahp > php then
		local extra = damage * pct
		local new_hp = php - extra
		if new_hp <= 0 then
			ComponentSetValue2(pdm, "hp", 0.001)
			EntityInflictDamage(player, 0.002, "DAMAGE_CURSE", "envy", "NONE", 0, 0, attacker)
		else
			ComponentSetValue2(pdm, "hp", new_hp)
		end
	elseif ahp < php then
		local refund = damage * pct
		local new_hp = php + refund
		if new_hp > pmax then new_hp = pmax end
		ComponentSetValue2(pdm, "hp", new_hp)
	end
end
