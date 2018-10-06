local vector3d, err = pcall(require, "libs/Vector3D")
if err and vector3d == false then
    vector3d, err = pcall(require, "Vector3D")
    if err and vector3d == false then
        client.log("Please download https://gamesense.pub/forums/viewtopic.php?id=5464 to use this script")
        client.log(err)
        return
    end
end

local enabled = ui.new_checkbox("visuals", "other esp", "Chickens")
local color = ui.new_color_picker("visuals", "other esp", "Chickens", 255, 255, 255, 255)

client.set_event_callback("paint", function(ctx)
    
    local chickens = entity.get_all("CChicken")
    
    if chickens == nil or not ui.get(enabled) then return end
    
    for i = 1, #chickens do
        local chicken = chickens[i]
        		
        local origin = Vector3(entity.get_prop(chicken, "m_vecOrigin"))
        local min = Vector3(entity.get_prop(chicken, "m_vecMins")) + origin
        local max = Vector3(entity.get_prop(chicken, "m_vecMaxs")) + origin

        local points = {
            Vector3(min.x, min.y, min.z),
            Vector3(min.x, max.y, min.z),
            Vector3(max.x, max.y, min.z),
            Vector3(max.x, min.y, min.z),
            Vector3(min.x, min.y, max.z),
            Vector3(min.x, max.y, max.z),
            Vector3(max.x, max.y, max.z),
            Vector3(max.x, min.y, max.z),
        }
        
        local edges = {
            {0, 1}, {1, 2}, {2, 3}, {3, 0},
            {5, 6}, {6, 7}, {1, 4}, {4, 8},
            {0, 4}, {1, 5}, {2, 6}, {3, 7},
            {5, 8}, {7, 8}, {3, 4},
        }
        
        local r, g, b, a = ui.get(color)
        
        for i = 1, #edges do
            if points[edges[i][1]] ~= nil and points[edges[i][2]] ~= nil then
                local p1 = Vector3(client.world_to_screen(ctx, points[edges[i][1]].x, points[edges[i][1]].y, points[edges[i][1]].z))
                local p2 = Vector3(client.world_to_screen(ctx, points[edges[i][2]].x, points[edges[i][2]].y, points[edges[i][2]].z))
                client.draw_line(ctx, p1.x, p1.y, p2.x, p2.y, r, g, b, a)
            end
        end

        local entity_pos = Vector3(entity.get_prop(chicken, "m_vecOrigin"))
        entity_pos = entity_pos + Vector3(0, 0, 28)
        local wx, wy = client.world_to_screen(ctx, entity_pos:unpack())
        if wx ~= nil then
            client.draw_text(ctx, wx, wy, 255,255,255,a, "c", 0, "Chicken")
        end
    end
end)
