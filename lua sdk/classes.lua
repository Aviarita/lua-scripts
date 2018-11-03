-- credits: Valve Corporation, lua.org, Aviarita, sapphyrus, "none", NmChris

require( "bit" )

-- localize vars
local type         = type
local setmetatable = setmetatable

local math_floor = math.floor
local math_ceil  = math.ceil
local math_pi    = math.pi
local math_min   = math.min
local math_max   = math.max
local math_deg   = math.deg
local math_rad   = math.rad
local math_sqrt  = math.sqrt
local math_sin   = math.sin
local math_cos   = math.cos
local math_atan  = math.atan
local math_acos  = math.acos
local math_fmod  = math.fmod

local band = bit.band

---------------------------------------------------------------------------------------------------------------
-------------------------------------			 Entity Class			  -------------------------------------
---------------------------------------------------------------------------------------------------------------

-- set up entity metatable
local entity_mt   = {}
entity_mt.__index = entity_mt

-- create entity object
function Entity(entindex)
    if type( entindex ) ~= "number"  then
        entindex = 0
    end

   entindex = entindex or 0

    return setmetatable(
        {
            entindex = entindex
        },
        entity_mt
    )
end

----------------------
--  misc functions  --
---------------------- 

function entity_mt:get_prop(prop, array_index) return entity.get_prop(self.entindex, prop, array_index or 0) end
function entity_mt:set_prop(prop, value, array_index) return entity.set_prop(self.entindex, prop, value, array_index or 0) end

--[[
	@params none
	@returns the classname of the entity
]]
function entity_mt:get_classname() 
	return entity.get_classname(self.entindex) 
end

--[[
	@params none
	@returns true if the entity and another entity have the same index
]]
function entity_mt:equals( entindex ) 
	return self.entindex == entindex 
end

--[[
	@params none
	@returns true if the entity is a player
]]
function entity_mt:is_player()
	return self:get_classname() == "CCSPlayer"
end

--[[
	@params none
	@returns true if the entity is a defuser
]]
function entity_mt:is_defuser()
	return self:get_classname() == "CEconEntity"
end

--[[
	@params none
	@returns entity index of the entity
]]
function entity_mt:get_index()
	return self.entindex
end

----------------------
-- normal functions --
---------------------- 
--[[
	@params none
	@returns simulation time of the entity
]]
function entity_mt:get_sim_time() 
	return self:get_prop("m_flSimulationTime") 
end

--[[
	@params none
	@returns tick base of the entity
]]
function entity_mt:get_tick_base()
	return self:get_prop("m_nTickBase")
end

-------------------------
-- gamesense functions --
-------------------------

--[[
	@params ctx - context from paint callback
	@returns a table containing topX, topY, botX, botY, alpha, width, height, middle_x, middle_y of the players box
]]
function entity_mt:get_bounding_box(ctx)
	local gbb = { topX, topY, botX, botY, alpha, width, height, middle_x, middle_y }
	gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = entity.get_bounding_box(ctx, self.entindex)
	gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    return gbb
end

----------------------
-- vector functions --
----------------------

--[[
	@params none
	@returns a table with the view offset x, y, z of the entity
]]
function entity_mt:get_vec_viewoffset( )
	local viewoffset = { x, y, z }
	viewoffset.x, viewoffset.y, viewoffset.z = self:get_prop("m_vecViewOffset")
	if type(viewoffset.x) == "nil" then
		viewoffset.x = 0.0
	end

	if type(viewoffset.y) == "nil" then
		viewoffset.y = 0.0
	end

	if type(viewoffset.z) == "nil" then
		viewoffset.z = 0.0
	end
	return viewoffset
end

--[[
	@params none
	@returns a table with the view punch angle x, y, z of the entity
]]
function entity_mt:get_view_punch_angle()
	local viewpunch = { x, y, z }
	viewpunch.x, viewpunch.y, viewpunch.z = self:get_prop("m_viewPunchAngle")
	if type(viewpunch.x) == "nil" then
		viewpunch.x = 0.0
	end

	if type(viewpunch.y) == "nil" then
		viewpunch.y = 0.0
	end

	if type(viewpunch.z) == "nil" then
		viewpunch.z = 0.0
	end
	return viewpunch
end

--[[
	@params none
	@returns a table with the aim punch angle x, y, z of the entity
]]
function entity_mt:get_aim_punch_angle()
	local aimpunch = { x, y, z }
	aimpunch.x, aimpunch.y, aimpunch.z = self:get_prop("m_aimPunchAngle")
	if type(aimpunch.x) == "nil" then
		aimpunch.x = 0.0
	end

	if type(aimpunch.y) == "nil" then
		aimpunch.y = 0.0
	end

	if type(aimpunch.z) == "nil" then
		aimpunch.z = 0.0
	end
	return aimpunch
end

--[[
	@params none
	@returns a table with the coordinates x, y, z of the entity
]]
function entity_mt:get_vec_origin()
	local origin = { x, y, z }
	origin.x, origin.y, origin.z = self:get_prop("m_vecOrigin")
	
	if type(origin.x) == "nil" then
		origin.x = 0.0
	end

	if type(origin.y) == "nil" then
		origin.x = 0.0
	end

	if type(origin.z) == "nil" then
		origin.x = 0.0
	end

	return origin
end

--[[
	@params none
	@returns a table with the vec_mins x, y, z of the entity
]]
function entity_mt:get_vec_mins()
	local vec_mins = { x, y, z }
	vec_mins.x, vec_mins.y, vec_mins.z = self:get_prop("m_vecMins")

	if type(vec_mins.x) == "nil" then
		vec_mins.x = 0.0
	end

	if type(vec_mins.y) == "nil" then
		vec_mins.x = 0.0
	end

	if type(vec_mins.z) == "nil" then
		vec_mins.x = 0.0
	end

	return vec_mins
end

--[[
	@params none
	@returns a table with the vec_maxs x, y, z of the entity
]]
function entity_mt:get_vec_maxs()
	local vec_maxs = { x, y, z }
	vec_maxs.x, vec_maxs.y, vec_maxs.z = self:get_prop("m_vecMaxs")

	if type(vec_maxs.x) == "nil" then
		vec_maxs.x = 0.0
	end

	if type(vec_maxs.y) == "nil" then
		vec_maxs.x = 0.0
	end

	if type(vec_maxs.z) == "nil" then
		vec_maxs.x = 0.0
	end

	return vec_maxs
end

--[[
	@params none
	@returns a table with the angles x, y, z of the entity
]]
function entity_mt:get_angles()
	local angles = { x, y, z }
	angles.x, angles.y, angles.z = self:get_prop("m_angEyeAngles")
	angles.x   = math_floor( angles.x )
	angles.y   = math_floor( angles.y )
	angles.z   = math_floor( angles.z )

	if type(angles.x) == "nil" then
		angles.x = 0.0
	end

	if type(angles.y) == "nil" then
		angles.y = 0.0
	end

	if type(angles.z) == "nil" then
		angles.z = 0.0
	end

	return angles
end

--[[
	@params none
	@returns a table with the velocity x, y, z of the player
]]
function entity_mt:get_vec_velocity()
	local velocity = { x, y, z }
	velocity.x, velocity.y, velocity.z = self:get_prop("m_vecVelocity")

	if type(velocity.x) == "nil" then
		velocity.x = 0.0
	end

	if type(velocity.y) == "nil" then
		velocity.y = 0.0
	end

	if type(velocity.z) == "nil" then
		velocity.z = 0.0
	end

	return velocity
end

--[[
	@params none
	@returns 3d velocity of the player
]]

function entity_mt:get_velocity_lenght3d()
	return math_floor(math_min(10000, math_sqrt( 
		( self:get_vec_velocity().x * self:get_vec_velocity().x ) +
		( self:get_vec_velocity().y * self:get_vec_velocity().y ) +
		( self:get_vec_velocity().z * self:get_vec_velocity().z ))+ 0.5)
	)
end

--[[
	@params none
	@returns 2d velocity of the player
]]
function entity_mt:get_velocity_lenght2d()
	return math_floor(math_min(10000, math_sqrt( 
		( self:get_vec_velocity().x * self:get_vec_velocity().x ) +
		( self:get_vec_velocity().y * self:get_vec_velocity().y ))+ 0.5)
	)
end


---------------------------------------------------------------------------------------------------------------
-------------------------------------			 Weapon Class			  -------------------------------------
---------------------------------------------------------------------------------------------------------------

-- set up weapon metatable
local weapon_mt = {}
weapon_mt.__index = weapon_mt

-- create weapon object
function Weapon(entindex)
    if type( entindex ) ~= "number" then
        entindex = 0
    end
    entindex = entindex or 0

    return setmetatable(
        {
            entindex = entindex
        },
        weapon_mt
    )
end

----------------------
--  misc functions  --
---------------------- 

function weapon_mt:get_prop(prop, array_index) return entity.get_prop(self.entindex, prop, array_index or 0) end
function weapon_mt:set_prop(prop, value, array_index) return entity.set_prop(self.entindex, prop, value, array_index or 0) end

--[[
	@params none
	@returns an instance of the entity metatable with the current weapon
]]
function weapon_mt:entity()
	return Entity(self.entindex)
end

--[[
	@params none
	@returns the entity index of the player's weapon
]]
function weapon_mt:get_index()
	return self.entindex
end

--[[
	@params none
	@returns a table with all values of the functions inside the metatable
]]
function weapon_mt:get_values()
	local values = {}
	values.meta_table = "Weapon metatable"
	values.get_index = self:get_index()
	values.get_item_definition_index = self:get_item_definition_index()
	values.get_name = self:get_name()
	values.get_accuracy_penalty = self:get_accuracy_penalty()
	values.get_zoom_level = self:get_zoom_level()
	values.get_next_primary_attack = self:get_next_primary_attack()
	values.get_current_ammo = self:get_current_ammo()
	values.get_max_ammo = self:get_max_ammo()
	values.get_primary_reserve_ammo = self:get_primary_reserve_ammo()
	values.get_recoil_index = self:get_recoil_index()
	values.has_bullets = self:has_bullets()
	values.get_post_pone_fire_ready_time = self:get_post_pone_fire_ready_time()
	values.get_last_shot_time = self:get_last_shot_time()
	return values
end

local knifes = {
	[41]  = true, -- Knife
	[42]  = true, -- Knife
	[59]  = true, -- Knife
	[500] = true, -- Bayonet
	[505] = true, -- Flip Knife
	[506] = true, -- Gut Knife
	[507] = true, -- Karambit
	[508] = true, -- M9 Bayonet
	[509] = true, -- Huntsman Knife
	[512] = true, -- Falchion Knife
	[514] = true, -- Bowie Knife
	[515] = true, -- Butterfly Knife
	[516] = true, -- Shadow Daggers
	[519] = true, -- Ursus Knife
	[520] = true, -- Navaja Knife
	[522] = true, -- Siletto Knife
	[523] = true, -- Talon Knife
}

--[[
	@params none
	@returns true if the weapon is a knife
]]
function weapon_mt:is_knife()
	return knifes[self:get_item_definition_index()] or false
end

local grenades = {
    [43] =  true, -- Flashbang
    [44] =  true, -- Grenade
    [45] =  true, -- Smoke
    [46] =  true, -- Molotov
    [47] =  true, -- Decoy
    [48] =  true, -- Incendiary
}

--[[
	@params none
	@returns true if the weapon is a grenade
]]
function weapon_mt:is_grenade()
	return grenades[self:get_item_definition_index()] or false
end

local pistols = {
 	[1]  = true, -- Desert Eagle
    [2]  = true, -- Dual Berettas
    [3]  = true, -- Five-SeveN
    [4]  = true, -- Glock-18
	[30] = true, -- Tec-9
    [32] = true, -- P2000
 	[61] = true, -- USP-S
    [63] = true, -- CZ75-Auto
    [64] = true, -- R8 Revolver
}

--[[
	@params none
	@returns true if the weapon is a pistol
]]
function weapon_mt:is_pistol()
	return pistols[self:get_item_definition_index()] or false
end

local rifles = {
 	[7]  = true, -- AK-47
    [8]  = true, -- AUG
	[10] = true, -- FAMAS
	[13] = true, -- Galil AR
	[16] = true, -- M4A4
	[39] = true, -- SG 553
	[60] = true, -- M4A1-S
}

--[[
	@params none
	@returns true if the weapon is a rifle
]]
function weapon_mt:is_rifle()
	return rifles[self:get_item_definition_index()] or false
end

local shotguns = {
	[25] = true, -- XM1014
	[27] = true, -- MAG-7
	[29] = true, -- Sawed-Off
	[35] = true, -- Nova
}

--[[
	@params none
	@returns true if the weapon is a shotgun
]]
function weapon_mt:is_shotgun()
	return shotguns[self:get_item_definition_index()] or false
end

local smgs = {
    [17] = true, -- MAC-10
    [19] = true, -- P90
    [23] = true, -- MP5-SD
    [24] = true, -- UMP-45
    [26] = true, -- PP-Bizon
    [33] = true, -- MP7
    [34] = true, -- MP9
}

--[[
	@params none
	@returns true if the weapon is a smg
]]
function weapon_mt:is_smg()
	return smgs[self:get_item_definition_index()] or false
end

local snipers = {
	[9]  = true, -- AWP
	[11] = true, -- G3SG1
	[38] = true, -- SCAR-20
	[40] = true, -- SSG 08
}

--[[
	@params none
	@returns true if the weapon is a sniper
]]
function weapon_mt:is_sniper()
	return snipers[self:get_item_definition_index()] or false
end

local heavys = {
    [14] = true, -- M249
    [28] = true, -- Negev
}

--[[
	@params none
	@returns true if the weapon is a heavy
]]
function weapon_mt:is_heavy()
	return heavys[self:get_item_definition_index()] or false
end

local misc_weapons = {
    [31] =  true, -- Taser
    [41] =  true, -- Knife
    [42] =  true, -- Knife
    [43] =  true, -- Flashbang
    [44] =  true, -- Grenade
    [45] =  true, -- Smoke
    [46] =  true, -- Molotov
    [47] =  true, -- Decoy
    [48] =  true, -- Incendiary
    [49] =  true, -- C4
    [59] =  true, -- Knife
    [500] = true, -- Bayonet
    [505] = true, -- Flip Knife
    [506] = true, -- Gut Knife
    [507] = true, -- Karambit
    [508] = true, -- M9 Bayonet
    [509] = true, -- Huntsman Knife
    [512] = true, -- Falchion Knife
    [514] = true, -- Bowie Knife
    [515] = true, -- Butterfly Knife
    [516] = true, -- Shadow Daggers
    [519] = true, -- Ursus Knife
    [520] = true, -- Navaja Knife
    [522] = true, -- Siletto Knife
    [523] = true, -- Talon Knife
}

--[[
	@params none
	@returns true if the weapon is a misc weapon
]]
function weapon_mt:is_misc_weapon()
	return misc_weapons[self:get_item_definition_index()] or false
end

----------------------
-- normal functions --
----------------------

--[[
	@params none
	@returns itemdefinitionindex of the player's weapon
]]
function weapon_mt:get_item_definition_index()
    return band(self:get_prop("m_iItemDefinitionIndex"), 0xFFFF)
end

local weapons = {
    [1] = "Desert Eagle",
    [2] = "Dual Berettas",
    [3] = "Five-SeveN",
    [4] = "Glock-18",
    [7] = "AK-47",
    [8] = "AUG",
    [9] = "AWP",
    [10] = "FAMAS",
    [11] = "G3SG1",
    [13] = "Galil AR",
    [14] = "M249",
    [16] = "M4A4",
    [17] = "MAC-10",
    [19] = "P90",
    [23] = "MP5-SD",
    [24] = "UMP-45",
    [25] = "XM1014",
    [26] = "PP-Bizon",
    [27] = "MAG-7",
    [28] = "Negev",
    [29] = "Sawed-Off",
    [30] = "Tec-9",
    [31] = "Taser",
    [32] = "P2000",
    [33] = "MP7",
    [34] = "MP9",
    [35] = "Nova",
    [36] = "P250",
    [38] = "SCAR-20",
    [39] = "SG 553",
    [40] = "SSG 08",
    [41] = "Knife",
    [42] = "Knife",
    [43] = "Flashbang",
    [44] = "HE Grenade",
    [45] = "Smoke",
    [46] = "Molotov",
    [47] = "Decoy",
    [48] = "Incendiary",
    [49] = "C4",
    [59] = "Knife",
    [60] = "M4A1-S",
    [61] = "USP-S",
    [63] = "CZ75-Auto",
    [64] = "R8 Revolver",
    [500] = "Bayonet",
    [505] = "Flip Knife",
    [506] = "Gut Knife",
    [507] = "Karambit",
    [508] = "M9 Bayonet",
    [509] = "Huntsman Knife",
    [512] = "Falchion Knife",
    [514] = "Bowie Knife",
    [515] = "Butterfly Knife",
    [516] = "Shadow Daggers",
    [519] = "Ursus Knife",
    [520] = "Navaja Knife",
    [522] = "Siletto Knife",
    [523] = "Talon Knife",
}

--[[
	 @params none
	 @returns weapon name of the player's weapon
]]
function weapon_mt:get_name()
	return weapons[self:get_item_definition_index()]
end

--[[
	@params none
	@returns accuracy penalty of the player's weapon
]]
function weapon_mt:get_accuracy_penalty()
	return self:get_prop("m_fAccuracyPenalty")
end

--[[
	@params none
	@returns zoom level of the player's weapon
]]
function weapon_mt:get_zoom_level()
	return self:get_prop("m_zoomLevel")
end

--[[
	@params none
	@returns 
]]
function weapon_mt:get_next_primary_attack()
	return self:get_prop("m_flNextPrimaryAttack")
end

--[[
	@params none
	@returns current ammo of the player's weapon
]]
function weapon_mt:get_current_ammo()
	return self:get_prop("m_iClip1")
end

local ammo = {
    [1] = 7, -- Deagle
    [2] = 30, -- Duals
    [3] = 20, -- five seven
    [4] = 20, -- glock
    [7] = 30, -- ak
    [8] = 30, -- aug
    [9] = 10,  -- awp
    [10] = 25, -- famas
    [11] = 20, -- t auto
    [13] = 35, -- galil
    [14] = 100, -- ms249
    [16] = 30, -- m4a4
    [17] = 30,-- mac 10
    [19] = 50,-- p90
    [23] = 30, -- mp5-sd
    [24] = 25,-- ump
    [25] = 7,-- xm1014
    [26] = 64,-- bizon
    [27] = 5,-- mag7
    [28] = 150, -- negev
    [29] = 7, -- sawed off
    [30] = 18, -- tec9
    [32] = 13, -- p2k
    [33] = 30, -- mp7
    [34] = 30, -- mp9
    [35] = 8, -- nova
    [36] = 13, -- p250
    [38] = 20, -- ct auto
    [39] = 30, -- sg553
    [40] = 10, -- scout
    [60] = 20, -- m4a1s
    [61] = 12, -- usps
    [63] = 12, -- cz75
    [64] = 8, -- revolvo
}

--[[
	@params none
	@returns max ammo of the player's weapon
]]
function weapon_mt:get_max_ammo()
	return ammo[self:get_item_definition_index()]
end

--[[
	@params
	@returns primary reserve ammo of the player's weapon
]]
function weapon_mt:get_primary_reserve_ammo()
	return self:get_prop("m_iPrimaryReserveAmmoCount")
end

--[[
	@params none
	@returns recoilindex of the player's weapon
]]
function weapon_mt:get_recoil_index()
	return self:get_prop("m_flRecoilIndex")
end

--[[
	@params none
	@returns true if the weapon has bullets left
]]
function weapon_mt:has_bullets()
	return self:get_current_ammo() > 0
end

--[[
	@params none
	@returns postpone fire ready time of the player's weapon
]]
function weapon_mt:get_post_pone_fire_ready_time()
	return self:get_prop("m_flPostponeFireReadyTime")
end

--[[
	@params none
	@returns last shot time of the player's weapon
]]
function weapon_mt:get_last_shot_time()
	return self:get_prop("m_fLastShotTime")
end


-----------------------
-- Grenade functions --
-----------------------

--[[
	@params none
	@returns true if the pin of the player's active grenade is pulled
]]
function weapon_mt:is_pin_pulled()
	return self:get_prop("m_bPinPulled") == 1
end

--[[
	@params none
	@returns throwtime of the player's active grenade
]]
function weapon_mt:get_throw_time()
	return self:get_prop("m_fThrowTime")
end

---------------------------------------------------------------------------------------------------------------
---------------------------------			 Playerresource Class			  ---------------------------------
---------------------------------------------------------------------------------------------------------------

-- set up playerresource metatable
local playerresource_mt = {}
playerresource_mt.__index = playerresource_mt

-- set up global playerresource metatable
local global_playerresource_mt = {}
global_playerresource_mt.__index = global_playerresource_mt

-- create playerresource object
function Playerresource(entindex)
    local resource = entity.get_all("CCSPlayerResource")[1]
    if type( entindex ) ~= "number" then
    	return setmetatable(
    	    {
    	        resource = resource
    	    },
    	    global_playerresource_mt
    	)
    elseif type( entindex ) == "number" then
        entindex = entindex or 0
    	return setmetatable(
    	    {
    	        entindex = entindex,
    	        resource = resource
    	    },
    	    playerresource_mt
    	)
    end

end

----------------------
--  misc functions  --
---------------------- 

function playerresource_mt:get_prop(prop) return entity.get_prop(self.resource, prop, self.entindex) end
function playerresource_mt:set_prop(prop, value) return entity.set_prop(self.resource, prop, value, self.entindex) end
function global_playerresource_mt:get_prop(prop) return entity.get_prop(self.resource, prop) end
function global_playerresource_mt:set_prop(prop, value) return entity.set_prop(self.resource, prop, value) end


--[[
	@params none
	@returns a table with all values of the functions inside the metatable
]]
function playerresource_mt:get_values()
	local values = {}
	values.meta_table = "Playerresource metatable"
	values.get_ping					= self:get_ping()
	values.get_kills				= self:get_kills()
	values.get_deaths				= self:get_deaths()
	values.get_assists				= self:get_assists()
	values.get_mvps					= self:get_mvps()
	values.get_score				= self:get_score()
	values.get_matchmaking_rank		= self:get_matchmaking_rank()
	values.get_matchmaking_wins		= self:get_matchmaking_wins()
	values.get_clantag				= self:get_clantag()
	values.get_health				= self:get_health()
	values.get_armor				= self:get_armor()
	values.is_alive					= self:is_alive()
	return values
end

----------------------
-- normal functions --
----------------------

--[[
	@params none
	@returns ping of the player
]]
function playerresource_mt:get_ping()
	return self:get_prop("m_iPing")
end

--[[
	@params none
	@returns kills of the player
]]
function playerresource_mt:get_kills()
	return self:get_prop("m_iKills")
end

--[[
	@params none
	@returns deaths of the player
]]
function playerresource_mt:get_deaths()
	return self:get_prop("m_iDeaths")
end

--[[
	@params none
	@returns assists of the player
]]
function playerresource_mt:get_assists()
	return self:get_prop("m_iAssist")
end

--[[
	@params none
	@returns mvps of the player
]]
function playerresource_mt:get_mvps()
	return self:get_prop("m_iMVPs")
end

--[[
	@params none
	@returns score of the player
]]
function playerresource_mt:get_score()
	return self:get_prop("m_iScore")
end

local ranks = {
	[0]  = "Unranked",

	[1]  = "Silver I",
	[2]  = "Silver II",
	[3]  = "Silver III",
	[4]  = "Silver IV",
	[5]  = "Silver Elite",
	[6]  = "Silver Elite Master",

	[7]  = "Gold Nova I",
	[8]  = "Gold Nova II",
	[9]  = "Gold Nova III",
	[10] = "Gold Nova Master",

	[11] = "Master Guardian I",
	[12] = "Master Guardian II",
	[13] = "Master Guardian Elite",
	[14] = "Distinguished Master Guardian",

	[15] = "Legendary Eagle",
	[16] = "Legendary Eagle Master",
	[17] = "Supreme Master First Class",
	[18] = "The Global Elite",
}

--[[
	@params none
	@returns matchmaking rank of the player
]]
function playerresource_mt:get_matchmaking_rank()
	return ranks[self:get_prop("m_iCompetitiveRanking")]
end

--[[
	@params none
	@returns matchmaking wins of the player
]]
function playerresource_mt:get_matchmaking_wins()
	return self:get_prop("m_iCompetitiveWins")
end

--[[
	@params none
	@returns clantag of the player
]]
function playerresource_mt:get_clantag()
	return self:get_prop("m_szClan")
end

--[[
	@params none
	@returns health of the player, works on dormant players
]]
function playerresource_mt:get_health()
	return self:get_prop("m_iHealth")
end

--[[
	@params none
	@returns armor of the player, works on dormant players
]]
function playerresource_mt:get_armor()
	return self:get_prop("m_iArmor")
end

--[[
	@params none
	@returns true if the player is alive, works one dormant players
]]
function playerresource_mt:is_alive()
	return self:get_prop("m_bAlive") == 1
end

--[[
	@params none
	@returns true if the player has a helmet, works one dormant players
]]
function playerresource_mt:has_helmet()
	return self:get_prop("m_bHasHelmet") == 1
end

--[[
	@params none
	@returns true if the player has a defuser, works one dormant players
]]
function playerresource_mt:has_defuser()
	return self:get_prop("m_bHasDefuser") == 1
end

----------------------
-- global functions --
----------------------s

--[[
	@params none
	@returns entity index of the player holding the c4
]]
function global_playerresource_mt:get_player_c4()
	return self:get_prop("m_iPlayerC4")
end

--[[
	@params none
	@returns a table with all hostage entity indexes
]]
function global_playerresource_mt:get_hostages()
	local hostage = {}
	for i = 1, #entity.get_all("CHostage") do
		table.insert(hostage, entity.get_all("CHostage")[i])
	end
	return hostage
end

--[[
	@params none
	@returns a table with the coordinates of bombsite a
]]
function global_playerresource_mt:get_bombsite_center_a()
	local bombsitecentera = { x, y, z }
	bombsitecentera.x, bombsitecentera.y, bombsitecentera.z = self:get_prop("m_bombsiteCenterA")

	if type(bombsitecentera.x) == "nil" then
		bombsitecentera.x = 0.0
	end

	if type(bombsitecentera.y) == "nil" then
		bombsitecentera.y = 0.0
	end

	if type(bombsitecentera.z) == "nil" then
		bombsitecentera.z = 0.0
	end

	return bombsitecentera
end

--[[
	@params none
	@returns a table with the coordinates of bombsite b
]]
function global_playerresource_mt:get_bombsite_center_b()
	local bombsitecenterb = { x, y, z }
	bombsitecenterb.x, bombsitecenterb.y, bombsitecenterb.z = self:get_prop("m_bombsiteCenterA")

	if type(bombsitecenterb.x) == "nil" then
		bombsitecenterb.x = 0.0
	end

	if type(bombsitecenterb.y) == "nil" then
		bombsitecenterb.y = 0.0
	end

	if type(bombsitecenterb.z) == "nil" then
		bombsitecenterb.z = 0.0
	end

	return bombsitecenterb
end


---------------------------------------------------------------------------------------------------------------
-------------------------------------			 Player Class			  -------------------------------------
---------------------------------------------------------------------------------------------------------------

-- set up player metatable
local player_mt   = {}
player_mt.__index = player_mt

-- create player object
function Player(entindex)
    if type( entindex ) ~= "number" then
        entindex = 0
    end
    entindex = entindex or 0

    return setmetatable(
        {
            entindex = entindex
        },
        player_mt
    )
end

----------------------
--  misc functions  --
---------------------- 

function player_mt:get_prop(prop, array_index) return entity.get_prop(self.entindex, prop, array_index or 0) end
function player_mt:set_prop(prop, value, array_index) return entity.set_prop(self.entindex, prop, value, array_index or 0) end

--[[
	@params none
	@returns true if the entity and the specified entity have have the same index
]]
function player_mt:equals( entindex ) return self.entindex == entindex end

--[[
	@params none
	@returns true if the player is the local player
]]
function player_mt:is_local_player()
	return entindex == entity.get_local_player()
end


--[[
	@params none
	@returns entity index of the player
]]
function player_mt:get_index()
	return self.entindex
end

--[[
	@params none
	@returns an instance of the entity metatable with the current player
]]
function player_mt:entity()
	return Entity(self.entindex)
end

--[[
	@params none
	@returns a table with all values of the functions inside the metatable
]]
function player_mt:get_values()
	local values = {}
	values.meta_table = "Player metatable"
	values.get_active_weapon = self:get_active_weapon()
	values.get_all_weapons = self:get_all_weapons()
	values.get_lifestate = self:get_lifestate()
	values.get_lifestate_str = self:get_lifestate_str()
	values.get_health = self:get_health()
	values.get_teamnum = self:get_teamnum()
	values.get_sim_time = self:get_sim_time()
	values.has_defuser = self:has_defuser()
	values.get_team_str = self:get_team_str()
	values.get_shots_fired = self:get_shots_fired()
	values.get_armor_value = self:get_armor_value()
	values.has_helmet = self:has_helmet()
	values.is_scoped = self:is_scoped()
	values.get_flash_duration = self:get_flash_duration()
	values.get_flash_max_alpha = self:get_flash_max_alpha()
	values.is_flashed = self:is_flashed()
	values.get_tick_base = self:get_tick_base()
	values.get_flags = self:get_flags()
	values.get_buttons = self:get_buttons()
	values.is_ducked = self:is_ducked()
	values.is_ducking = self:is_ducking()
	values.get_duck_time = self:get_duck_time()
	values.get_duck_speed = self:get_duck_speed()
	values.get_falling_velocity = self:get_falling_velocity()
	values.get_observe_mode = self:get_observe_mode()
	values.get_observe_mode = self:get_observe_mode()
	values.can_attack = self:can_attack()
	values.get_money = self:get_money()
	values.get_hitbox_set = self:get_hitbox_set()
	values.has_bomb = self:has_bomb()
	values.get_name = self:get_name()
	values.is_enemy = self:is_enemy()
	values.is_alive = self:is_alive()
	values.is_dormant = self:is_dormant()
	values.get_vec_viewoffset = self:get_vec_viewoffset()
	values.get_view_punch_angle = self:get_view_punch_angle()
	values.get_aim_punch_angle = self:get_aim_punch_angle()
	-- Adding those lines will cause client.log not to display the values
	values.get_vec_origin = self:get_vec_origin()
	values.get_vec_mins = self:get_vec_mins()
	values.get_vec_maxs = self:get_vec_maxs()
	values.get_angles = self:get_angles()
	values.get_angle_rotation = self:get_angle_rotation()
	values.get_vec_velocity = self:get_vec_velocity()
	values.get_velocity_lenght3d = self:get_velocity_lenght3d()
	values.get_velocity_lenght2d = self:get_velocity_lenght2d()
	values.get_eye_pos = self:get_eye_pos()
	return values
end

--[[
	@params none
	@returns an instance of the weapon metatable with the current weapon of the player
]]
function player_mt:get_active_weapon()
	return Weapon(entity.get_player_weapon(self.entindex))
end

--[[
	@params none
	@returns a table with all weapons, can be passed to the weapon metatable
	@credits sapphyrus
]]
function player_mt:get_all_weapons()
	local weapons = {}
	for i=0, 64 do
		local weapon = self:get_prop("m_hMyWeapons", i)
		if weapon ~= nil then
			table.insert(weapons, Weapon(weapon))
		end
	end
	return weapons
end

--[[
	@params none
	@returns an instance of the playerresource metatable with the current player
]]
function player_mt:playerresource()
	return Playerresource(self.entindex)
end

----------------------
-- normal functions --
---------------------- 

--[[
	@params none
	@returns lifestate of the player
]]
function player_mt:get_lifestate() 
	return self:get_prop("m_lifestate") 
end

local lifestates = {
	[0] = "Alive",
	[1] = "Dying",
	[2] = "Dead",
}

--[[
	@params none
	@returns lifestate of the player as a string
]]
function player_mt:get_lifestate_str()
	return lifestates[self:get_lifestate()]
end

--[[
	@params none
	@returns health of the player
]]
function player_mt:get_health()
 	return self:get_prop("m_iHealth")
end

--[[
	@params opt entity index
	@returns team number of the player
]]
function player_mt:get_teamnum() 
	return self:get_prop("m_iTeamNum") 
end

--[[
	@params none
	@returns simulation time of the player
]]
function player_mt:get_sim_time() 
	return self:get_prop("m_flSimulationTime") 
end

--[[
	@params none
	@returns true if the player has a defuser
]]
function player_mt:has_defuser() 
	return self:get_prop("m_bHasDefuser") == 1
end

local teams = {
	[0] = "None",
	[1] = "Spec",
	[2] = "T",
	[3] = "CT",
}
--[[
	@params none
	@returns team name as a string of the player
]]
function player_mt:get_team_str()
	return teams[self:get_teamnum()] 
end

--[[
	@params none
	@returns how many shots the player has fired since in_attack
]]
function player_mt:get_shots_fired()
	return self:get_prop("m_iShotsFired")
end

--[[
	@params none
	@returns armor of the player
]]
function player_mt:get_armor_value()
	return self:get_prop("m_ArmorValue")
end

--[[
	@params none
	@returns true if the player has a helmet
]]
function player_mt:has_helmet()
	return self:get_prop("m_bHasHelmet") == 1
end

--[[
	@params none
	@returns true if the player is scoped
]]
function player_mt:is_scoped()
	return self:get_prop("m_bIsScoped") == 1
end

--[[
	@params none
	@returns true if the player is scoped
]]
function player_mt:get_flash_duration()
	return self:get_prop("m_flFlashDuration")
end

--[[
	@params value - 0.0 - 1.0
	@returns nothing
]]
function player_mt:set_flash_max_alpha(value)
	return self:set_prop("m_flFlashDuration", value)
end

--[[
	@params none
	@returns true if the player is scoped
]]
function player_mt:get_flash_max_alpha()
	return self:get_prop("m_flFlashMaxAlpha")
end

--[[
	@params value - 0 - 255
	@returns nothing
]]
function player_mt:set_flash_max_alpha(value)
	return self:set_prop("m_flFlashMaxAlpha", value)
end

--[[
	@params none
	@returns true if the player is flashed
]]
function player_mt:is_flashed()
	return self:get_prop("m_flFlashDuration") > 0
end

--[[
	@params none
	@returns tick base of the player
]]
function player_mt:get_tick_base()
	return self:get_prop("m_nTickBase")
end

--[[
	@params none
	@returns value of the player's flags
]]
function player_mt:get_flags()
	return self:get_prop("m_fFlags")
end

--[[
	@params none
	@returns value of the player's buttons
]]
function player_mt:get_buttons()
	return self:get_prop("m_nButtons")
end

--[[
	@params none
	@returns true if the player is ducked
]]
function player_mt:is_ducked()
	return self:get_prop("m_bDucked") == 1
end

--[[
	@params none
	@returns true if the player is ducking
]]
function player_mt:is_ducking()
	return self:get_prop("m_bDucking") == 1
end

--[[
	@params none
	@returns duck amount of the player
]]
function player_mt:get_duck_time()
	return self:get_prop("m_flDuckAmount")
end

--[[
	@params none
	@returns duck amount of the player
]]
function player_mt:get_duck_speed()
	return self:get_prop("m_flDuckSpeed")
end

--[[
	@params none
	@returns falling velocity of the player
]]
function player_mt:get_falling_velocity()
	return self:get_prop("m_flFallVelocity")
end

--[[
	@params none
	@returns observe mode of the player
]]
function player_mt:get_observe_mode()
	return self:get_prop("m_iObserverMode")
end

--[[
	@params none
	@returns observe mode of the player
]]
function player_mt:get_observe_mode()
	return self:get_prop("m_iObserverMode")
end

--[[
	@params none
	@returns true if the player can attack		
	@credits sapphyrus https://github.com/gamesensical/gquery/blob/master/src/gquery.lua#L450-L453
]]
function player_mt:can_attack()
	local next_attack = math_max(0, self:get_active_weapon():get_prop("m_flNextPrimaryAttack") or 0, self:get_prop("m_flNextAttack") or 0)
	return next_attack - globals.curtime() > 0
end

--[[
	@params none
	@returns money of the player
]]
function player_mt:get_money()
	return self:get_prop("m_iAccount")
end

--[[
	@params none
	@returns hitbox set of the player
]]
function player_mt:get_hitbox_set()
	return self:get_prop("m_nHitboxSet")
end

--[[
	@params none
	@returns true if the player has the bomb
]]
function player_mt:has_bomb()
	return self.entindex == Playerresource():get_player_c4()
end

--[[
	@params none
	@returns true if the player is grabbing a hostage
]]
function player_mt:is_grabbing_hostage()
	return self:get_prop("m_bIsGrabbingHostage") == 1
end

--[[
	@params none
	@returns true if the player is holding a hostage
]]
function player_mt:has_hostage()
	return self:get_prop("m_hCarriedHostage") ~= nil
end

-------------------------
-- gamesense functions --
-------------------------

--[[
	@params none
	@returns name of the player
]]
function player_mt:get_name() 
	return entity.get_player_name(self.entindex) 
end

--[[
	@params none
	@returns true if the player is alive
]]
function player_mt:is_enemy()
	return entity.is_enemy(self.entindex)
end

--[[
	@params none
	@returns true if the player is alive
]]
function player_mt:is_alive()
	return entity.is_alive(self.entindex)
end

--[[
	@params ctx - context from the paint callback
	@returns 
]]
function player_mt:get_bounding_box(ctx)
	local gbb = { topX, topY, botX, botY, alpha, width, height, middle_x, middle_y }
	gbb.topX, gbb.topY, gbb.botX, gbb.botY, gbb.alpha = entity.get_bounding_box(ctx, self.entindex)
	gbb.width, gbb.height = gbb.botX - gbb.topX, gbb.botY - gbb.topY
    gbb.middle_x = (gbb.topX - gbb.botX) / 2
    gbb.middle_y = (gbb.topY - gbb.botY) / 2
    return gbb
end

--[[
	@params none
	@returns true if the player is dormant
]]
function player_mt:is_dormant()
	return entity.is_dormant(self.entindex)
end

--[[
	@params endpos - a table with x, y and z coordinates of a point somewhere in the world
	@returns true if the endpos is visible
]]
function player_mt:can_see_point(endpos)
	local fraction, hit_entity = client.trace_line(entity.get_local_player(), self:get_eye_pos().x, self:get_eye_pos().y, self:get_eye_pos().z, endpos.x, endpos.y, endpos.z)
	return fraction > 0.97
end

--[[
	@params entindex - entity index of another player
	@returns true if the player can see the second player
]]
function player_mt:can_see_player(entindex)
	local player = Player(entindex)
	local fraction, hit_entity = client.trace_line(self.entindex, self:get_hitbox_pos("head_0").x, self:get_hitbox_pos("head_0").y, self:get_hitbox_pos("head_0").z, player:get_hitbox_pos("head_0").x, player:get_hitbox_pos("head_0").y, player:get_hitbox_pos("head_0").z)
	return hit_entity == entindex and fraction > 0.97
end

----------------------
-- vector functions --
---------------------- 

--[[
	@params hitbox - either a string of the hitbox name, or an integer index of the hitbox.
	@returns a table with the coordinates of the hitbox position
]]
function player_mt:get_hitbox_pos(hitbox)
	local position = { x, y, z }
	position.x, position.y, position.z = entity.hitbox_position(self.entindex, hitbox)
	
	if type(position.x) == "nil" then
		position.x = 0.0
	end

	if type(position.y) == "nil" then
		position.y = 0.0
	end

	if type(position.z) == "nil" then
		position.z = 0.0
	end

	return position
end

--[[
	@params none
	@returns a table with the view offset x, y, z of the player
]]
function player_mt:get_vec_viewoffset( )
	local viewoffset = { x, y, z }
	viewoffset.x, viewoffset.y, viewoffset.z = self:get_prop("m_vecViewOffset")
	if type(viewoffset.x) == "nil" then
		viewoffset.x = 0.0
	end

	if type(viewoffset.y) == "nil" then
		viewoffset.y = 0.0
	end
	
	if type(viewoffset.z) == "nil" then
		viewoffset.z = 0.0
	end
	return viewoffset
end

--[[
	@params none
	@returns a table with the view punch angle x, y, z of the player
]]
function player_mt:get_view_punch_angle()
	local viewpunch = { x, y, z }
	viewpunch.x, viewpunch.y, viewpunch.z = self:get_prop("m_viewPunchAngle")
	if type(viewpunch.x) == "nil" then
		viewpunch.x = 0.0
	end

	if type(viewpunch.y) == "nil" then
		viewpunch.y = 0.0
	end

	if type(viewpunch.z) == "nil" then
		viewpunch.z = 0.0
	end
	return viewpunch
end

--[[
	@params none
	@returns a table with the aim punch angle x, y, z of the player
]]
function player_mt:get_aim_punch_angle()
	local aimpunch = { x, y, z }
	aimpunch.x, aimpunch.y, aimpunch.z = self:get_prop("m_aimPunchAngle")
	if type(aimpunch.x) == "nil" then
		aimpunch.x = 0.0
	end

	if type(aimpunch.y) == "nil" then
		aimpunch.y = 0.0
	end

	if type(aimpunch.z) == "nil" then
		aimpunch.z = 0.0
	end
	return aimpunch
end

--[[
	@params none
	@returns a table with the coordinates x, y, z of the player
]]
function player_mt:get_vec_origin()
	local origin = { x, y, z }
	origin.x, origin.y, origin.z = self:get_prop("m_vecOrigin")

	if type(origin.x) == "nil" then
		origin.x = 0.0
	end

	if type(origin.y) == "nil" then
		origin.y = 0.0
	end

	if type(origin.z) == "nil" then
		origin.z = 0.0
	end

	return origin
end

--[[
	@params none
	@returns a table with the vec_mins x, y, z of the player
]]
function player_mt:get_vec_mins()
	local vec_mins = { x, y, z }
	vec_mins.x, vec_mins.y, vec_mins.z = self:get_prop("m_vecMins")

	if type(vec_mins.x) == "nil" then
		vec_mins.x = 0.0
	end

	if type(vec_mins.y) == "nil" then
		vec_mins.y = 0.0
	end

	if type(vec_mins.z) == "nil" then
		vec_mins.z = 0.0
	end

	return vec_mins
end

--[[
	@params none
	@returns a table with the vec_maxs x, y, z of the player
]]
function player_mt:get_vec_maxs()
	local vec_maxs = { x, y, z }
	vec_maxs.x, vec_maxs.y, vec_maxs.z = self:get_prop("m_vecMaxs")

	if type(vec_maxs.x) == "nil" then
		vec_maxs.x = 0.0
	end

	if type(vec_maxs.y) == "nil" then
		vec_maxs.y = 0.0
	end

	if type(vec_maxs.z) == "nil" then
		vec_maxs.z = 0.0
	end

	return vec_maxs
end

--[[
	@params none
	@returns a table with the angles x, y, z, lowerbodyyaw of the player
]]
function player_mt:get_angles()
	local angles = { x, y, z, lby }
	angles.x, angles.y, angles.z = self:get_prop("m_angEyeAngles")
	angles.lby = self:get_prop("m_flLowerBodyYawTarget")
	angles.x   = math_floor( angles.x )
	angles.y   = math_floor( angles.y )
	angles.z   = math_floor( angles.z )
	angles.lby = math_floor( angles.lby )

	if type(angles.x) == "nil" then
		angles.x = 0.0
	end

	if type(angles.y) == "nil" then
		angles.y = 0.0
	end

	if type(angles.z) == "nil" then
		angles.z = 0.0
	end

	if type(angles.lby) == "nil" then
		angles.lby = 0.0
	end

	return angles
end

--[[
	@params none
	@returns a table with the angle rotations x, y, z of the player
]]
function player_mt:get_angle_rotation()
	local angle_rotation = { x, y, z }
	angle_rotation.x, angle_rotation.y, angle_rotation.z = self:get_prop("m_angRotation")

	if type(angle_rotation.x) == "nil" then
		angle_rotation.x = 0.0
	end

	if type(angle_rotation.y) == "nil" then
		angle_rotation.y = 0.0
	end

	if type(angle_rotation.z) == "nil" then
		angle_rotation.z = 0.0
	end

	return angle_rotation
end

--[[
	@params none
	@returns a table with the velocity x, y, z of the player
]]
function player_mt:get_vec_velocity()
	local velocity = { x, y, z }
	velocity.x, velocity.y, velocity.z = self:get_prop("m_vecVelocity")

	if type(velocity.x) == "nil" then
		velocity.x = 0.0
	end

	if type(velocity.y) == "nil" then
		velocity.y = 0.0
	end

	if type(velocity.z) == "nil" then
		velocity.z = 0.0
	end

	return velocity
end

--[[
	@params none
	@returns 3d velocity of the player
]]

function player_mt:get_velocity_lenght3d()
	return math_floor(math_min(10000, math_sqrt( 
		( self:get_vec_velocity().x * self:get_vec_velocity().x ) +
		( self:get_vec_velocity().y * self:get_vec_velocity().y ) +
		( self:get_vec_velocity().z * self:get_vec_velocity().z ))+ 0.5)
	)
end

--[[
	@params none
	@returns 2d velocity of the player
]]
function player_mt:get_velocity_lenght2d()
	return math_floor(math_min(10000, math_sqrt( 
		( self:get_vec_velocity().x * self:get_vec_velocity().x ) +
		( self:get_vec_velocity().y * self:get_vec_velocity().y ))+ 0.5)
	)
end

--[[
	@params none
	@returns a table with the coordinates of the player's eye position 
	@disclaimer: may not be reliable 
]]
function player_mt:get_eye_pos()

	if self:is_local_player() then
		return client.eye_position()
	else

		local eye_pos = { x, y, z }
		eye_pos.x = self:get_vec_origin().x + self:get_vec_viewoffset().x
		eye_pos.y = self:get_vec_origin().y + self:get_vec_viewoffset().y
		eye_pos.z = self:get_vec_origin().z + self:get_vec_viewoffset().z
	
		if type(eye_pos.x) == "nil" then
			eye_pos.x = 0.0
		end
	
		if type(eye_pos.y) == "nil" then
			eye_pos.y = 0.0
		end
	
		if type(eye_pos.z) == "nil" then
			eye_pos.z = 0.0
		end

		return eye_pos
	end
	return 0, 0, 0
end


---------------------------------------------------------------------------------------------------------------
-----------------------------------            Localplayer Class            -----------------------------------
---------------------------------------------------------------------------------------------------------------

-- set up localplayer metatable
local localplayer_mt = {}
localplayer_mt.__index = localplayer_mt

-- create localplayer object
function LocalPlayer()
    return setmetatable(
        {
            entindex = entity.get_local_player(),
        },
        localplayer_mt
    )
end
--------------------
-- misc functions --
--------------------

function localplayer_mt:get_prop(prop, array_index) return entity.get_prop(self.entindex, prop, array_index or 0) end
function localplayer_mt:set_prop(prop, value, array_index) return entity.set_prop(self.entindex, prop, value, array_index or 0) end


--[[
	@params none
	@returns entity index of the player
]]
function localplayer_mt:get_index()
	return self.entindex
end

--[[
	@params none
	@returns an instance of the player metatable with the local player
]]
function localplayer_mt:player()
	return Player(self.entindex)
end

--[[
	@params none
	@returns an instance of the entity metatable with the local player
]]
function localplayer_mt:entity()
	return Entity(self.entindex)
end

--[[
	@params none
	@returns an instance of the weapon metatable with the current weapon of the local player
]]
function localplayer_mt:get_active_weapon()
	return Weapon(entity.get_player_weapon(self.entindex))
end

--[[
	@params none
	@returns an instance of the playerresource metatable with the local player
]]
function localplayer_mt:playerresource()
	return Playerresource(self.entindex)
end


---------------------------------------------------------------------------------------------------------------
---------------------------------            GameRulesProxy Class            ----------------------------------
---------------------------------------------------------------------------------------------------------------

-- set up gamerulesproxy metatable
local gamerulesproxy_mt = {}
gamerulesproxy_mt.__index = gamerulesproxy_mt

-- create gamerulesproxy object
function Gamerulesproxy()
    return setmetatable(
        {
            resource = entity.get_all("CCSGameRulesProxy")[1]
        },
        gamerulesproxy_mt
    )
end

function gamerulesproxy_mt:get_values()
	local values = {}
	values.is_freezetime = self:is_freezetime()
	values.is_queued_for_matchmaking = self:is_queued_for_matchmaking()
	values.is_valve_ds = self:is_valve_ds()
	values.is_bomb_dropped = self:is_bomb_dropped()
	values.is_bomb_planted = self:is_bomb_planted()
	values.meta_table = "Gamerulesproxy metatable"
	values.resource = self.resource
	return values
end

--------------------
-- misc functions --
--------------------

function gamerulesproxy_mt:get_prop(prop, array_index) return entity.get_prop(self.resource, prop, array_index or 0) end
function gamerulesproxy_mt:set_prop(prop, value, array_index) return entity.set_prop(self.resource, prop, value, array_index or 0) end

----------------------
-- normal functions --
----------------------

--[[
	@params none
	@returns true if the freezetime is active
]]
function gamerulesproxy_mt:is_freezetime()
	return self:get_prop("m_bFreezePeriod") == 1
end

--[[
	@params none
	@returns true if you are queued for matchmaking
]]
function gamerulesproxy_mt:is_queued_for_matchmaking()
	return self:get_prop("m_bIsQueuedMatchmaking") == 1
end

--[[
	@params none
	@returns true if you are on a valve server
]]
function gamerulesproxy_mt:is_valve_ds()
	return self:get_prop("m_bIsValveDS") == 1
end

--[[
	@params none
	@returns true if the bomb is dropped
]]
function gamerulesproxy_mt:is_bomb_dropped()
	return self:get_prop("m_bBombDropped") == 1
end

--[[
	@params none
	@returns true if the bomb is planted
]]
function gamerulesproxy_mt:is_bomb_planted()
	return self:get_prop("m_bBombPlanted") == 1
end

