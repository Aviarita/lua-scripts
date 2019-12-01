## Information

Weapon models will flicker, player models shouldn't

## Steps to add your own models
1. Download them from ![here](https://gamebanana.com/skins/games/4660) and follow the instructions in the readme files/threads.
2. Open the lua file
3. Find the tables **player_models** and **weapon_models**
4. If you have a custom player model add a new entry to **player_models**, if you have a custom weapon model add a new entry to **weapon_models**
5. Reload the lua

A few examples:
```lua
local player_models = {
    ["Emilia"] = "models/player/custom_player/maoling/re0/emilia_v2/emilia.mdl",
    ["Hitler"] = "models/player/custom_player/kuristaja/hitler/hitler.mdl",
    ["Neptunia"] = "models/player/custom_player/maoling/neptunia/adult_neptune/normal/adult.mdl",
    ["Freddy krueger"] = "models/player/freddykrueger/freddykrueger_update.mdl",
    ["Pokemon trainer"] = "models/player/pokemon/pokemon_trainer/pokemon_trainer.mdl",
}

local weapon_models = {
	[7] = "models/weapons/v_ak47royalguard.mdl", -- weapon_ak47
	[9] = "models/weapons/eminem/dsr_50/v_dsr_50_2.mdl", -- weapon_awp
	[35] = "models/weapons/eminem/gold_fararm_atf_12/v_gold_fararm_atf_12.mdl", -- weapon_nova
	[42] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[44] = "models/weapons/v_snowball.mdl", -- weapon_hegrenade
	[59] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[80] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[500] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[503] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[505] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[506] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[507] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[508] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[509] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[512] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[514] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[515] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[516] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[519] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[520] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[522] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[521] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[525] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[518] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[517] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
	[523] = "models/weapons/v_cfaxegold.mdl", -- weapon_knife
}

```
