local player_models = {
    -- [Menu name] = path to model
    ["Hitler"] = "models/player/custom_player/kuristaja/hitler/hitler.mdl", -- example line path/to/model 
}

local weapon_models = {
    -- [Weapon index] = path to model
	[1] = " ", -- weapon_deagle
	[2] = " ", -- weapon_elite
	[3] = " ", -- weapon_fiveseven
	[4] = " ", -- weapon_glock
	[7] = " ", -- weapon_ak47
	[8] = " ", -- weapon_aug
	[9] = " ", -- weapon_awp
	[10] = " ", -- weapon_famas
	[11] = " ", -- weapon_g3sg1
	[13] = " ", -- weapon_galilar
	[14] = " ", -- weapon_m249
	[16] = " ", -- weapon_m4a1
	[17] = " ", -- weapon_mac10
	[19] = " ", -- weapon_p90
	[23] = " ", -- weapon_mp7
	[24] = " ", -- weapon_ump45
	[25] = " ", -- weapon_xm1014
	[26] = " ", -- weapon_bizon
	[27] = " ", -- weapon_mag7
	[28] = " ", -- weapon_negev
	[29] = " ", -- weapon_sawedoff
	[30] = " ", -- weapon_tec9
	[31] = " ", -- weapon_taser
	[32] = " ", -- weapon_hkp2000
	[33] = " ", -- weapon_mp7
	[34] = " ", -- weapon_mp9
	[35] = " ", -- weapon_nova
	[36] = " ", -- weapon_p250
	[37] = " ", -- weapon_shield
	[38] = " ", -- weapon_scar20
	[39] = " ", -- weapon_sg556
	[40] = " ", -- weapon_ssg08
	[41] = " ", -- weapon_knifegg
	[42] = " ", -- weapon_knife
	[43] = " ", -- weapon_flashbang
	[44] = " ", -- weapon_hegrenade
	[45] = " ", -- weapon_smokegrenade
	[46] = " ", -- weapon_molotov
	[47] = " ", -- weapon_decoy
	[48] = " ", -- weapon_incgrenade
	[49] = " ", -- weapon_c4
	[57] = " ", -- weapon_healthshot
	[59] = " ", -- weapon_knife
	[60] = " ", -- weapon_m4a1
	[61] = " ", -- weapon_hkp2000
	[63] = " ", -- weapon_p250
	[64] = " ", -- weapon_deagle
	[68] = " ", -- weapon_tagrenade
	[70] = " ", -- weapon_breachcharge
	[72] = " ", -- weapon_tablet
	[74] = " ", -- weapon_melee
	[75] = " ", -- weapon_melee
	[76] = " ", -- weapon_melee
	[78] = " ", -- weapon_melee
	[80] = " ", -- weapon_knife
	[81] = " ", -- weapon_molotov
	[82] = " ", -- weapon_decoy
	[83] = " ", -- weapon_hegrenade
	[84] = " ", -- weapon_snowball
	[85] = " ", -- weapon_bumpmine
	[500] = " ", -- weapon_knife
	[503] = " ", -- weapon_knife
	[505] = " ", -- weapon_knife
	[506] = " ", -- weapon_knife
	[507] = " ", -- weapon_knife
	[508] = " ", -- weapon_knife
	[509] = " ", -- weapon_knife
	[512] = " ", -- weapon_knife
	[514] = " ", -- weapon_knife
	[515] = " ", -- weapon_knife
	[516] = " ", -- weapon_knife
	[519] = " ", -- weapon_knife
	[520] = " ", -- weapon_knife
	[522] = " ", -- weapon_knife
	[521] = " ", -- weapon_knife
	[525] = " ", -- weapon_knife
	[518] = " ", -- weapon_knife
	[517] = " ", -- weapon_knife
	[523] = " ", -- weapon_knife
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local ffi = require("ffi")

ffi.cdef[[
    typedef struct 
    {
    	void*   fnHandle;        
    	char    szName[260];     
    	int     nLoadFlags;      
    	int     nServerCount;    
    	int     type;            
    	int     flags;           
    	float  vecMins[3];       
    	float  vecMaxs[3];       
    	float   radius;          
    	char    pad[0x1C];       
    }model_t;
    
    typedef int(__thiscall* get_model_index_t)(void*, const char*);
    typedef const model_t(__thiscall* find_or_load_model_t)(void*, const char*);
    typedef int(__thiscall* add_string_t)(void*, bool, const char*, int, const void*);
    typedef void*(__thiscall* find_table_t)(void*, const char*);
    typedef void(__thiscall* set_model_index_t)(void*, int);
    typedef int(__thiscall* precache_model_t)(void*, const char*, bool);
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

local class_ptr = ffi.typeof("void***")

local rawientitylist = client.create_interface("client_panorama.dll", "VClientEntityList003") or error("VClientEntityList003 wasnt found", 2)
local ientitylist = ffi.cast(class_ptr, rawientitylist) or error("rawientitylist is nil", 2)
local get_client_entity = ffi.cast("get_client_entity_t", ientitylist[0][3]) or error("get_client_entity is nil", 2)

local rawivmodelinfo = client.create_interface("engine.dll", "VModelInfoClient004") or error("VModelInfoClient004 wasnt found", 2)
local ivmodelinfo = ffi.cast(class_ptr, rawivmodelinfo) or error("rawivmodelinfo is nil", 2)
local get_model_index = ffi.cast("get_model_index_t", ivmodelinfo[0][2]) or error("get_model_info is nil", 2)
local find_or_load_model = ffi.cast("find_or_load_model_t", ivmodelinfo[0][39]) or error("find_or_load_model is nil", 2)

local rawnetworkstringtablecontainer = client.create_interface("engine.dll", "VEngineClientStringTable001") or error("VEngineClientStringTable001 wasnt found", 2)
local networkstringtablecontainer = ffi.cast(class_ptr, rawnetworkstringtablecontainer) or error("rawnetworkstringtablecontainer is nil", 2)
local find_table = ffi.cast("find_table_t", networkstringtablecontainer[0][3]) or error("find_table is nil", 2)

local model_names = {}
for k,v in pairs(player_models) do
    table.insert(model_names, k)
end

local replace_models = ui.new_checkbox("lua", "a", "Replace weapon models")
local replace_player_models = ui.new_checkbox("lua", "a", "Replace player models")
local t_choosen_player_model = ui.new_combobox("lua", "a", "T model", model_names)
local ct_choosen_player_model = ui.new_combobox("lua", "a", "CT model", model_names)

local function precache_model(modelname)
    local rawprecache_table = find_table(networkstringtablecontainer, "modelprecache") or error("couldnt find modelprecache", 2)
    if rawprecache_table then 
        local precache_table = ffi.cast(class_ptr, rawprecache_table) or error("couldnt cast precache_table", 2)
        if precache_table then 
            local add_string = ffi.cast("add_string_t", precache_table[0][8]) or error("add_string is nil", 2)

            find_or_load_model(ivmodelinfo, modelname)
            local idx = add_string(precache_table, false, modelname, -1, nil)
            if idx == -1 then 
                return false
            end
        end
    end
    return true
end

local function set_model_index(entity, idx)
    local raw_entity = get_client_entity(ientitylist, entity)
    if raw_entity then 
        local gce_entity = ffi.cast(class_ptr, raw_entity)
        local a_set_model_index = ffi.cast("set_model_index_t", gce_entity[0][75])
        if a_set_model_index == nil then 
            error("set_model_index is nil")
        end
        a_set_model_index(gce_entity, idx)
    end
end

local function change_model(ent, model, isWeapon, ent2)
    if model:len() > 5 then 
        if precache_model(model) == false then 
            error("invalid model", 2)
        end
        local idx = get_model_index(ivmodelinfo, model)
        if idx == -1 then 
            return
        end
        set_model_index(ent, idx)
    end
end

local update_skins = true
client.set_event_callback("net_update_start", function()

    local me = entity.get_local_player()
    if me == nil then return end

    if ui.get(replace_player_models) then 
        local players = entity.get_players(false)
        for i=1, #players do 
            local player = players[i]
            local teamnum = entity.get_prop(player, "m_iTeamNum")
            if entity.is_alive(player) and not entity.is_dormant(player) then 
                if teamnum == 2 then
                    change_model(player, player_models[ui.get(t_choosen_player_model)], false)
                elseif teamnum == 3 then
                    change_model(player, player_models[ui.get(ct_choosen_player_model)], false)
                end
            end
        end
    end

    if ui.get(replace_models) then 
        local m_hViewModel = entity.get_prop(me, "m_hViewModel[0]")
        if m_hViewModel == nil then return end
    
        local m_hWeapon = entity.get_prop(m_hViewModel, "m_hWeapon")
        if m_hWeapon == nil then return end
        
        if entity.get_prop(m_hWeapon, "m_iItemDefinitionIndex") == nil then return end
        local wpn_idx = bit.band(entity.get_prop(m_hWeapon, "m_iItemDefinitionIndex"), 0xFFFF)
        if wpn_idx == nil then return end

        if weapon_models[wpn_idx] ~= nil then 
            change_model(m_hViewModel, weapon_models[wpn_idx])
            change_model(m_hWeapon, weapon_models[wpn_idx])
            if update_skins then 
                cvar.cl_fullupdate:invoke_callback()
                update_skins = false
            end
        else
            update_skins = true
        end
    end
end)
