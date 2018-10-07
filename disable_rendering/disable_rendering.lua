local activation = ui.new_checkbox("visuals", "effects", "Disable rendering of enemies")
client.set_event_callback("paint", function()
	local players = entity.get_players(false)
	for i=1, #players do
		if entity.get_prop(players[i], "m_iTeamNum") ~= entity.get_prop(entity.get_local_player(), "m_iTeamNum") and ui.get(activation) then
			entity.set_prop(players[i], "m_nRenderMode", 6)
		elseif not ui.get(activation) then
			entity.set_prop(players[i], "m_nRenderMode", 0)
		end
	end
end)
