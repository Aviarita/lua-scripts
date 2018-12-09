local vector3d, err = pcall(require, "libs/Vector3D")
if err and vector3d == false then
    vector3d, err = pcall(require, "Vector3D")
    if err and vector3d == false then
        client.log("Please download https://gamesense.pub/forums/viewtopic.php?id=5464")
        client.log("or https://github.com/Aviarita/lua-scripts/blob/master/libs/Vector3D.lua to use this script")
        client.log(err)
        return
    end
end

local ffi = require "ffi"
ffi.cdef[[
typedef struct {
    int     command_number;     // 0x04 For matching server and client commands for debugging
    float   pitch;
    float   yaw;
    float    forwardmove;
    float    sidemove;
    union {
        unsigned int buttons;
        struct {
            unsigned int in_attack : 1;
            unsigned int in_jump : 1;
            unsigned int in_duck : 1;
            unsigned int in_forward : 1;
            unsigned int in_back : 1;
            unsigned int in_use : 1;
            unsigned int in_cancel : 1;
            unsigned int in_left : 1;
            unsigned int in_right : 1;
            unsigned int in_moveleft : 1;
            unsigned int in_moveright : 1;
            unsigned int in_attack2 : 1;
            unsigned int in_run : 1;
            unsigned int in_reload : 1;
            unsigned int in_alt1 : 1;
            unsigned int in_alt2 : 1;
            unsigned int in_score : 1;
            unsigned int in_speed : 1;
            unsigned int in_walk : 1;
            unsigned int in_zoom : 1;
            unsigned int in_weapon1 : 1;
            unsigned int in_weapon2 : 1;
            unsigned int in_bullrush : 1;
            unsigned int in_grenade1 : 1;
            unsigned int in_grenade2 : 1;
            unsigned int in_attack3 : 1;
            unsigned int in_unused : 6;
        };
    };
} CUserCmd;
]]
local ffi_cast = ffi.cast
local ct_usercmd = ffi.typeof('CUserCmd*')


local GetUi = ui.get
local NewCheckbox = ui.new_checkbox
local NewRef = ui.reference
local SetVisible = ui.set_visible
local SetCallback = ui.set_callback

local Log = client.log
local AddEvent = client.set_event_callback
local GetLocalPlayer = entity.get_local_player
local GetProp = entity.get_prop
local SetProp = entity.set_prop

local ui = {
	enabled = NewCheckbox("misc","miscellaneous", "Anti-teamkill"),
	ignore_while_spraying = NewCheckbox("misc", "miscellaneous", "Ignore while spraying"),
	ragebot = NewRef("rage", "aimbot", "enabled"),
}

-- credits to sapphyrus
local function get_crosshair_entity(skip_entindex, max_distance)
    local skip_entindex = skip_entindex ~= nil and skip_entindex or GetLocalPlayer()
    local max_distance = max_distance ~= nil and max_distance or 8192

    local pitch, yaw = client.camera_angles()

    local fwd = angle_forward(Vector3(pitch, yaw, 0))
    local start_pos = Vector3(client.eye_position())
    local end_pos = start_pos + (fwd * max_distance)

    local x1, y1, z1 = start_pos:unpack()

    local fraction, entindex_hit = client.trace_line(skip_entindex, x1, y1, z1, end_pos:unpack())
    return entindex_hit, fraction
end

-- credits end --

SetVisible(ui.ignore_while_spraying, false)
SetCallback(ui.enabled, function()
	SetVisible(ui.ignore_while_spraying, GetUi(ui.enabled))
end)

local function is_grenade_or_bomb(weapon_id)
    local weapon_item_index = GetProp(weapon_id, "m_iItemDefinitionIndex")
    if weapon_item_index == 43 then -- flashbang
        return true
        
    elseif weapon_item_index == 44 then -- he
        return true
        
    elseif weapon_item_index == 45 then -- smoke
        return true
        
    elseif weapon_item_index == 46 then -- molotov
        return true
        
    elseif weapon_item_index == 47 then -- decoy
        return true
        
    elseif weapon_item_index == 48 then -- incendiary
        return true
        
    elseif weapon_item_index == 49 then -- bomb
        return true
    else
        return false
    end
end

AddEvent("setup_command", function(cmd)
    local cmd = ffi_cast(ct_usercmd, cmd)

    if not GetUi(ui.enabled) then 
		return 
	end
	if GetUi(ui.ragebot) then return end

	local shots_fired = GetProp(GetLocalPlayer(), "m_iShotsFired")

	if shots_fired > 2 and GetUi(ui.ignore_while_spraying) then return end

	local is_grenade = is_grenade_or_bomb(entity.get_player_weapon(GetLocalPlayer()))

	if is_grenade then
	 	return 
	end

	local player = get_crosshair_entity()
	if not player then return end
    
	if GetProp(player, "m_iTeamNum") == GetProp(GetLocalPlayer(), "m_iTeamNum") then
		cmd.in_attack = 0
	end
end)
