local js = require("access_panorama")
js.eval([[
    var PartyChat = $('#MainMenu').FindChildInLayoutFile('PartyChat');
    var elChatContainer = PartyChat.FindChildInLayoutFile('ChatContainer');
    var elChatInput = PartyChat.FindChildInLayoutFile('ChatInput');

    function call_x_times(times, callback) {
        for (var i = 1; i <= times; i++){
            callback();
        }
    }
]])

ui.new_button("lua", "a", "Clear lobby chat", function()
	js.eval([[
		if (FriendsListAPI.IsLocalPlayerPlayingMatch()) {
	        elChatInput.text = "-﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽-﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽-﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽ ﷽﷽ ﷽﷽﷽ ﷽"
        }
        else {
		    elChatInput.text = ("     ").repeat(200);
        }
        call_x_times(50, () => {
            PartyChat.SubmitChatText();
        });
        elChatInput.text = ""
        PartyChat.ScrollToBottom();
	]])
end)

-- chat
local chat_looped = nil 
local chat_looped_delay = nil 
local chat_times = nil 

local chattext = nil 

local function send_message()
    js.eval([[
        elChatInput.text = "]]..ui.get(chattext).. [["
        call_x_times(]]..ui.get(chat_times).. [[, ()=>{
            PartyChat.SubmitChatText();
        });
        elChatInput.text = ""
        PartyChat.ScrollToBottom();
    ]])
	if ui.get(chat_looped) == false then return end
	client.delay_call(ui.get(chat_looped_delay) / 1000, send_message)
end

chat_looped = ui.new_checkbox("lua", "a", "Looped")
chat_looped_delay = ui.new_slider("lua", "a", "\n", 1, 1000, 100, true, "ms")
ui.new_button("lua", "a", "Send chat message", function()
	send_message()
end)
chattext = ui.new_textbox("lua", "a", "chat message")
chat_times = ui.new_slider("lua", "a", "\n", 1, 250, 1)
---

-- color
local color_looped = nil 
local color_looped_delay = nil 
local color_times = nil 

local function change_color()
    js.eval([[
        call_x_times(]]..ui.get(color_times).. [[, ()=>{
            LobbyAPI.ChangeTeammateColor();
        });
    ]])
	if ui.get(color_looped) == false then return end
	client.delay_call(ui.get(color_looped_delay) / 1000, change_color)
end

color_looped = ui.new_checkbox("lua", "a", "Looped")
color_looped_delay = ui.new_slider("lua", "a", "\n", 1, 1000, 100, true, "ms")
ui.new_button("lua", "a", "Change color", function()
	change_color()
end)
color_times = ui.new_slider("lua", "a", "\n", 1, 250, 1)
---
