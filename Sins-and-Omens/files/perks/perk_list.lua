table.insert(perk_list, {
	id = "greed",
	ui_name = "$perk_greed",
	ui_description = "$perkdesc_greed",
	ui_icon = "mods/Sins-and-Omens/files/perks/greed_icon.png",
	perk_icon = "mods/Sins-and-Omens/files/perks/greed_icon.png",
	usable_by_enemies = false,
	not_in_default_perk_pool = false,
	stackable = STACKABLE_YES,
	stackable_maximum = 10,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("greed_perk")
		local stacks = tonumber(GlobalsGetValue("SINS_OMENS_GREED_STACKS", "0")) or 0
		stacks = math.min(stacks + 1, 10)
		GlobalsSetValue("SINS_OMENS_GREED_STACKS", tostring(stacks))
	end,
	func_remove = nil,
	deprecated = nil,
	author = "intrepid",
	local_content = true,
	default = true,
})

table.insert(perk_list, {
	id = "sloth",
	ui_name = "$perk_sloth",
	ui_description = "$perkdesc_sloth",
	ui_icon = "mods/Sins-and-Omens/files/perks/sloth_icon.png",
	perk_icon = "mods/Sins-and-Omens/files/perks/sloth_icon.png",
	usable_by_enemies = false,
	not_in_default_perk_pool = false,
	stackable = 0,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("sloth_perk")
	end,
	func_remove = nil,
	deprecated = nil,
	author = "intrepid",
	local_content = true,
	default = true,
})

table.insert(perk_list, {
	id = "wrath",
	ui_name = "$perk_wrath",
	ui_description = "$perkdesc_wrath",
	ui_icon = "mods/Sins-and-Omens/files/perks/wrath_icon.png",
	perk_icon = "mods/Sins-and-Omens/files/perks/wrath_icon.png",
	usable_by_enemies = false,
	not_in_default_perk_pool = false,
	stackable = STACKABLE_YES,
	stackable_maximum = 3,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("wrath_perk")
		local stacks = tonumber(GlobalsGetValue("SINS_OMENS_WRATH_STACKS", "0")) or 0
		stacks = math.min(stacks + 1, 3)
		GlobalsSetValue("SINS_OMENS_WRATH_STACKS", tostring(stacks))
	end,
	func_remove = nil,
	deprecated = nil,
	author = "intrepid",
	local_content = true,
	default = true,
})
