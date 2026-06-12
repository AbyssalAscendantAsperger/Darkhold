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
	id = "pride",
	ui_name = "$perk_pride",
	ui_description = "$perkdesc_pride",
	ui_icon = "mods/Sins-and-Omens/files/perks/pride_icon.png",
	perk_icon = "mods/Sins-and-Omens/files/perks/pride_icon.png",
	usable_by_enemies = false,
	not_in_default_perk_pool = false,
	stackable = 0,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("pride_perk")
	end,
	func_remove = nil,
	deprecated = nil,
	author = "intrepid",
	local_content = true,
	default = true,
})

table.insert(perk_list, {
	id = "gluttony",
	ui_name = "$perk_gluttony",
	ui_description = "$perkdesc_gluttony",
	ui_icon = "mods/Sins-and-Omens/files/perks/gluttony_icon.png",
	perk_icon = "mods/Sins-and-Omens/files/perks/gluttony_icon.png",
	usable_by_enemies = false,
	not_in_default_perk_pool = false,
	stackable = 0,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("gluttony_perk")
	end,
	func_remove = nil,
	deprecated = nil,
	author = "intrepid",
	local_content = true,
	default = true,
})

table.insert(perk_list, {
	id = "envy",
	ui_name = "$perk_envy",
	ui_description = "$perkdesc_envy",
	ui_icon = "mods/Sins-and-Omens/files/perks/envy_icon.png",
	perk_icon = "mods/Sins-and-Omens/files/perks/envy_icon.png",
	usable_by_enemies = false,
	not_in_default_perk_pool = false,
	stackable = STACKABLE_YES,
	stackable_maximum = 4,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("envy_perk")
		local stacks = tonumber(GlobalsGetValue("SINS_OMENS_ENVY_STACKS", "0")) or 0
		stacks = math.min(stacks + 1, 4)
		GlobalsSetValue("SINS_OMENS_ENVY_STACKS", tostring(stacks))
	end,
	func_remove = nil,
	deprecated = nil,
	author = "intrepid",
	local_content = true,
	default = true,
})

table.insert(perk_list, {
	id = "lust",
	ui_name = "$perk_lust",
	ui_description = "$perkdesc_lust",
	ui_icon = "mods/Sins-and-Omens/files/perks/lust_icon.png",
	perk_icon = "mods/Sins-and-Omens/files/perks/lust_icon.png",
	usable_by_enemies = false,
	not_in_default_perk_pool = false,
	stackable = 0,
	func = function(entity_perk_item, entity_who_picked, item_name)
		GameAddFlagRun("lust_perk")
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
