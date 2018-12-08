local ffi = require "ffi"
ffi.cdef[[
typedef struct {
    float x;
    float y; 
} Vector2;
typedef struct {
    int     command_number;     // 0x04 For matching server and client commands for debugging
    Vector2   viewangles;
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
	int     weaponselect;      
	int     weaponsubtype;     
	int     random_seed;       
	short   mousedx;           
	short   mousedy;           
	bool    hasbeenpredicted;  
} CUserCmd;
]]
local ffi_cast = ffi.cast
local ct_usercmd = ffi.typeof('CUserCmd*')

local slidewalk = ui.new_checkbox("misc", "miscellaneous", "Slidewalk")

client.set_event_callback('setup_command', function(ctx)
    local cmd = ffi_cast(ct_usercmd, ctx)

    local move_type = entity.get_prop(entity.get_local_player(), "m_MoveType")

    if move_type == 9 then return end -- disable when on ladder
    if cmd.in_use == 1 then return end -- disable when holding e

    if ui.get(slidewalk) then
        if (cmd.forwardmove > 0) then
            cmd.in_back = 1
            cmd.in_forward = 0
        end
     
        if (cmd.forwardmove < 0) then
            cmd.in_forward = 1
            cmd.in_back = 0
        end
     
        if (cmd.sidemove < 0) then
            cmd.in_moveright = 1
            cmd.in_moveleft = 0
        end
    
        if (cmd.sidemove > 0) then
            cmd.in_moveleft = 1
            cmd.in_moveright = 0
        end
    end
end)
