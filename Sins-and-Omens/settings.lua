dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "Sins-and-Omens"
mod_settings_version = 1

local function mod_setting_rounded_slider_change(mod_id, gui, in_main_menu, setting, old_value, new_value)
	ModSettingSetNextValue(mod_setting_get_id(mod_id, setting), math.floor(new_value + 0.5), false)
end

mod_settings = {
	{
		category_id = "sins",
		ui_name = "SINS",
		ui_description = "Set each sin's starting stack (0 = disabled).",
		settings = {
			{
				id = "greed",
				ui_name = "  GREED",
				ui_description = "Gold to HP per tick. Each stack reduces the grace period.",
				value_default = 0,
				value_min = 0,
				value_max = 10,
				value_display_multiplier = 1,
				value_display_formatting = " $0 / 10",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn = mod_setting_rounded_slider_change,
			},
			{
				id = "sloth",
				ui_name = "  SLOTH",
				ui_description = "Hold ALT to phase through walls and scout.",
				value_default = 0,
				value_min = 0,
				value_max = 1,
				value_display_multiplier = 1,
				value_display_formatting = " $0",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn = mod_setting_rounded_slider_change,
			},
			{
				id = "wrath",
				ui_name = "  WRATH",
				ui_description = "Reflect damage to attackers. Each stack increases reflection power.",
				value_default = 0,
				value_min = 0,
				value_max = 3,
				value_display_multiplier = 1,
				value_display_formatting = " $0 / 3",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn = mod_setting_rounded_slider_change,
			},
			{
				id = "pride",
				ui_name = "  PRIDE",
				ui_description = "Untouchable while levitating — but the ground keeps a ledger.",
				value_default = 0,
				value_min = 0,
				value_max = 1,
				value_display_multiplier = 1,
				value_display_formatting = " $0",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn = mod_setting_rounded_slider_change,
			},
			{
				id = "gluttony",
				ui_name = "  GLUTTONY",
				ui_description = "Devour resistances of slain enemies.",
				value_default = 0,
				value_min = 0,
				value_max = 1,
				value_display_multiplier = 1,
				value_display_formatting = " $0",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn = mod_setting_rounded_slider_change,
			},
			{
				id = "envy",
				ui_name = "  ENVY",
				ui_description = "Scale damage by HP comparison. Each stack amplifies the effect.",
				value_default = 0,
				value_min = 0,
				value_max = 4,
				value_display_multiplier = 1,
				value_display_formatting = " $0 / 4",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn = mod_setting_rounded_slider_change,
			},
			{
				id = "lust",
				ui_name = "  LUST",
				ui_description = "Your touch seduces — polymorph cannot claim you.",
				value_default = 0,
				value_min = 0,
				value_max = 1,
				value_display_multiplier = 1,
				value_display_formatting = " $0",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn = mod_setting_rounded_slider_change,
			},
		},
	},
}

function ModSettingsUpdate(init_scope)
	local old_version = mod_settings_get_version(mod_id)
	mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
	return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
	mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end