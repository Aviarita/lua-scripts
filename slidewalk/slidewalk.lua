local slidewalk = ui.new_checkbox("misc", "miscellaneous", "Slidewalk")
client.set_event_callback('setup_command', function(cmd)

    local move_type = entity.get_prop(entity.get_local_player(), "m_MoveType")

    if move_type == 9 then return end -- disable when on a ladder
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
