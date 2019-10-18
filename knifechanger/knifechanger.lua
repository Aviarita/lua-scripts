-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, client_create_interface, client_set_event_callback, entity_get_local_player, entity_get_prop, entity_set_prop, require, ui_get, ui_new_checkbox, ui_new_combobox, ui_new_textbox, ui_reference, ui_set, ui_set_callback, ui_set_visible = bit.band, client.create_interface, client.set_event_callback, entity.get_local_player, entity.get_prop, entity.set_prop, require, ui.get, ui.new_checkbox, ui.new_combobox, ui.new_textbox, ui.reference, ui.set, ui.set_callback, ui.set_visible

local ffi = require("ffi")
ffi.cdef("typedef int(__thiscall* get_model_index_t)(void*, const char*)")
local ivmodelinfo = ffi.cast(ffi.typeof("void***"), client_create_interface("engine.dll", "VModelInfoClient004"))
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2])

local knife_options_ref_cb, knife_options_ref_cm = ui_reference("skins", "knife options", "override knife")
ui_set_visible(knife_options_ref_cb, false)
ui_set_visible(knife_options_ref_cm, false)

local knifiesc = {
    "Bayonet", "Flip", "Gut", 
    "Karambit", "M9 Bayonet", 
    "Tactical", "Butterfly", 
    "Falchion", "Shadow dagger", 
    "Survival bowie", "Ursus", 
    "Navaja", "Stiletto", "Talon", 
    "Spectral shiv", "Classic Knife"
}

local models = {
    ["Spectral shiv"] = "models/weapons/v_knife_ghost.mdl",
    ["Classic Knife"] = "models/weapons/v_knife_css.mdl",
}

local indices = {
    ["Spectral shiv"] = 505,
    ["Classic Knife"] = 503,
}

local knife_options_cb = ui_new_checkbox("skins", "knife options", "Override knife")
local knife_options_cmb = ui_new_combobox("skins", "knife options", "\nknife models", knifiesc)
local weaponkit_enable = ui_reference("skins", "weapon skin", "enabled")
local weaponkit_stattrack = ui_reference("skins", "weapon skin", "stattrak")

ui_set_callback(knife_options_cmb, function(self)
    local cur = ui_get(self)
    if models[cur] == nil then 
        if ui_get(knife_options_cb) then 
            ui_set(knife_options_ref_cb, true)
        end
        ui_set(knife_options_ref_cm, cur)
    else
        cvar.cl_fullupdate:invoke_callback()
        ui_set(knife_options_ref_cb, false)
    end
end)

ui_set_callback(knife_options_cb, function(self)
    if models[ui_get(knife_options_cmb)] == nil then 
        ui_set(knife_options_ref_cb, ui_get(self))
    end
end)

local knifes = {
	[41]  = true, -- Knife
	[42]  = true, -- Knife
    [59]  = true, -- Knife
    [80]  = true, -- spectral knife
	[500] = true, -- Bayonet
    [503] = true, -- CSS Knife
	[505] = true, -- Flip Knife
	[506] = true, -- Gut Knife
	[507] = true, -- Karambit
	[508] = true, -- M9 Bayonet
	[509] = true, -- Huntsman Knife
	[512] = true, -- Falchion Knife
	[514] = true, -- Bowie Knife
	[515] = true, -- Butterfly Knife
	[516] = true, -- Shadow Daggers
	[519] = true, -- Ursus Knife
	[520] = true, -- Navaja Knife
	[522] = true, -- Siletto Knife
    [523] = true, -- Talon Knife
}

local function get_all_weapons(ent)
	local weapons = {}
    for i=0, 64 do
        local weapon = entity_get_prop(ent, "m_hMyWeapons", i)
		if weapon ~= nil then
			table.insert(weapons, weapon)
		end
	end
	return weapons
end

local update_skins = false
local function update_knife_model(m_hWeapon, m_hViewModel, model_index, wpn_idx)
    entity_set_prop(m_hWeapon, "m_iItemDefinitionIndex", wpn_idx)
    if ui_get(weaponkit_enable) and ui_get(weaponkit_stattrack) then 
        entity_set_prop(m_hWeapon, "m_iEntityQuality", 3)
    end
    entity_set_prop(m_hViewModel, "m_nModelIndex", model_index) 
    
    if update_skins then 
        cvar.cl_fullupdate:invoke_callback()
        update_skins = false
    end
end

client_set_event_callback("net_update_end", function()
    local me = entity_get_local_player()
    if me == nil then return end

    local m_hViewModel = entity_get_prop(me, "m_hViewModel[0]")
    if m_hViewModel == nil then return end

    local m_hWeapon = entity_get_prop(m_hViewModel, "m_hWeapon")
    if m_hWeapon == nil then return end

    if entity.is_alive(me) == false then return end
    
    local wpn_idx = bit_band(entity_get_prop(m_hWeapon, "m_iItemDefinitionIndex") or 0, 0xFFFF)
    if wpn_idx == nil then return end

    if ui_get(knife_options_cb) then 
        if knifes[wpn_idx] then 
            local m_iItemDefinitionIndex = indices[ui_get(knife_options_cmb)] or wpn_idx
            local model_index = get_model_index(ivmodelinfo, models[ui_get(knife_options_cmb)])
            update_knife_model(m_hWeapon, m_hViewModel, model_index, m_iItemDefinitionIndex)
        else
            update_skins = true
        end
    end   
end)

client.set_event_callback("shutdown", function()
    ui_set_visible(knife_options_ref_cb, true)
    ui_set_visible(knife_options_ref_cm, true)
end)
