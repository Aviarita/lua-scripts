local plist_ref = ui.reference("players", "players", "player list")
local disable_vis = ui.reference("players", "adjustments", "disable visuals")
local max_distance = ui.new_slider("visuals", "player esp", "Max distance", 0, 500, 250, true, "ft")

local function get_distance_in_feet(a_x, a_y, a_z, b_x, b_y, b_z)
    return math.ceil(math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2)) * 0.0254 / 0.3048)
end

client.set_event_callback("paint", function(ctx)
    local players = entity.get_players(true)

    local lpo = {x,y,z}
    lpo.x, lpo.y, lpo.z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")

    for i=1, #players do 
        local eo = {x,y,z}
        eo.x, eo.y, eo.z = entity.get_prop(i, "m_vecOrigin")
            
        if eo-.x == nil then return end

        local distance = get_distance_in_feet(lpo.x,lpo.y,lpo.z,eo.x,eo.y,eo.z)

        if distance > ui.get(max_distance) then
            ui.set(plist_ref, i)
            ui.set(disable_vis, true)
        else
            ui.set(plist_ref, i)
            ui.set(disable_vis, false)
        end
    end
end)
