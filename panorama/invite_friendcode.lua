local js = require("access_panorama")
client.set_event_callback("console_input", function(cmd)
    if cmd:sub(1, 6) == "invite" then
        -- "invite " is 7 chars long
        if cmd:len() > 7 then
            local xuid = cmd:sub(8, -1)
            js.eval([[
                var xuid = FriendsListAPI.GetXuidFromFriendCode("]]..xuid..[["); 
                var name = FriendsListAPI.GetFriendName(xuid); 
                if (LobbyAPI.IsSessionActive() == false) { 
                    LobbyAPI.CreateSession(); 
                } 
                FriendsListAPI.ActionInviteFriend(xuid, ''); 
                $.Msg(`Invited \"${name}\" to the lobby..`);
            ]])
        else
            client.color_log(163, 163, 163, "invite <friendcode> - invites the given friendcode to the lobby, creates a lobby if none existed")
        end
        return true
    end
end)
