local js = require("access_panorama")

js.eval([[
    let collectedSteamIDS = [];
    collectedSteamIDS.push("123");
]])

local refresh = false
local function refresh_nearbies()
    client.delay_call(5, refresh_nearbies)
    if not refresh then 
        return
    end
    js.eval([[
        PartyBrowserAPI.Refresh();
        var lobbies = PartyBrowserAPI.GetResultsCount();
        for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
            var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
            if (!collectedSteamIDS.includes(xuid)) {
                if (collectedSteamIDS.includes('123')) {
                    collectedSteamIDS.splice(collectedSteamIDS.indexOf('123'), 1);
                }
                collectedSteamIDS.push(xuid);
                $.Msg(`Adding ${xuid} to the collection..`);
            }
        }
        $.Msg(`Mass invite collection: ${collectedSteamIDS.length}`);
    ]]) 
end
refresh_nearbies()
local auto_refresh_nearbies = ui.new_checkbox("lua", "a", "Auto refresh nearbies")
ui.set_callback(auto_refresh_nearbies, function(self)
    refresh = ui.get(self)
end)
ui.new_button("lua", "a", "Refresh nearbies", function()
    js.eval([[
        PartyBrowserAPI.Refresh();
        var lobbies = PartyBrowserAPI.GetResultsCount();
        for (var lobbyid = 0; lobbyid < lobbies; lobbyid++) {
            var xuid = PartyBrowserAPI.GetXuidByIndex(lobbyid);
            if (!collectedSteamIDS.includes(xuid)) {
                if (collectedSteamIDS.includes('123')) {
                    collectedSteamIDS.splice(collectedSteamIDS.indexOf('123'), 1);
                }
                collectedSteamIDS.push(xuid);
                $.Msg(`Adding ${xuid} to the collection..`);
            }
        }
        $.Msg(`Mass invite collection: ${collectedSteamIDS.length}`);
    ]]) 
end)
ui.new_button("lua", "a", "Mass invite nearbies", function()
    js.eval([[
        collectedSteamIDS.forEach(xuid => {
            FriendsListAPI.ActionInviteFriend(xuid, "");
        });
    ]])
end)
ui.new_button("lua", "a", "Print invite collection", function()
    js.eval([[
        $.Msg(collectedSteamIDS);
    ]])
end)
ui.new_button("lua", "a", "Invite all friends", function()
    js.eval([[
        var friends = FriendsListAPI.GetCount();
        for (var id = 0; id < friends; id++) {
            var xuid = FriendsListAPI.GetXuidByIndex(id);
            FriendsListAPI.ActionInviteFriend(xuid, "");
        }
    ]]) 
end)
