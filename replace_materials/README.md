## Steps to add your own materials
1. Download them from [here](https://gamebanana.com/skins/games/4660) and extract it.
2. Open the lua file
3. Find the tables **weapon_materials** and add your shit to it
4. Unload and then load the lua, DO NOT RELOAD IT OTHERWISE YOU WILL CRASH

A few examples:
```lua
local weapon_models = {
	[1] = "models/weapons/v_models/gold_pist_deagle/pist_deagle", -- weapon_deagle
	[7] = "models/weapons/v_models/dragonlore_rif_ak47/ak47", -- weapon_ak47
	[9] = "models/weapons/v_models/snip_awp_trace/awp", -- weapon_awp
}
```
