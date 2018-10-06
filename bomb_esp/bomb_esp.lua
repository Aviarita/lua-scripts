local cb, color = ui.reference("visuals", "other esp", "bomb")

local function get_bomb_time(bomb)
    local bomb_time = entity.get_prop(bomb, "m_flC4Blow") - globals.curtime()
    return bomb_time or 0
end

client.set_event_callback("paint", function(ctx)
    if not ui.get(cb) then return end
    local c4 = entity.get_all("CPlantedC4")[1]
    if c4 ~= nil and entity.get_prop(c4, "m_bBombDefused") == 0 and get_bomb_time(c4) > 0 then
        local r,g,b,a = ui.get(color)
        local epx, epy, epz = entity.get_prop(c4, "m_vecOrigin")
        epz = epz + 6
        local wx, wy = client.world_to_screen(ctx, epx, epy, epz)
        if wx ~= nil then
            client.draw_text(ctx, wx, wy, r, g, b, a, "c-", 0, "BOMB")
        end
    end
end)
