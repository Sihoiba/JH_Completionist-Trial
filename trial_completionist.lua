function killOnSight(self, being, player)
	if being.data and being.data.ai.group ~= "player" then
		if being.health.current > 0 then 
			being.health.current = 1
			world:get_level():apply_damage( self, being, 100, ivec2(), "pierce", player )
		end		
	end
end

register_blueprint "runtime_murder"
{
    callbacks = {       
        on_timer = [[
			function ( self, first )
				if first then return 49 end
				local level = world:get_level()
				for t in level:targets( world:get_player(), 8 ) do
					killOnSight(self, t, world:get_player())
				end
				return 50
			end
		]],
		on_action = [=[
            function ( self, entity, time_passed, last )
                if time_passed > 0 then
                    local level = world:get_level()
					for t in level:targets( world:get_player(), 8 ) do
						killOnSight(self, t, world:get_player())
					end
                end
                return 0
            end
        ]=],
    },
}

register_blueprint "trial_completionist"
{
    text = {
        name 		= "Completionist",
        desc   		= "{!COMPLETIONIST MOD}\nYou not going to rest until have seen every last part of every single base accross Jupiter and its moons.\n\n You will visit every single floor, every branch and every special level on every moon.\nThere are new enemies to keep you on your toes and to ensure there is still a challenge and variety as you do many more levels than normal.",
        abbr   		= "Comp",
        mortem_line = "He wanted to see everything!"
    },
    challenge = {
        type  = "trial",
		group = "trial_completionist",
		score = true,
    },
    callbacks = {
        on_create_player = [[
            function( self, player ) 
				player:attach( "runtime_murder" )
            end
        ]],		
    },
}

register_world "trial_completionist"
{
	on_create = function( seed )
		local data = world.setup( seed )
		
		world.add_branch {
			name       = "CALLISTO",
			depth      = 1,
			episode    = 1,
			size       = 7,
			enemy_list = "callisto",
			quest = {
				list = "callisto",
			},
			events     = {
				{ "event_volatile_storage", 2.0, max_level = 3 },
				{ "event_lockdown", 2.0, },
				"event_desolation",
				"event_low_light",
				{ "event_infestation", 1.0, min_level = 4, },
				{ "event_vault", 1.0, min_level = 4, },
				{ "event_hunt", 1.0, min_level = 5, },
				{ "event_contamination", 1.0, min_level = 5, },
			},
			event      = { 100, math.random_pick{2,3,5,6,4,2,3,5}, },
			generator = {
				[5] = { 
					"civilian_01_open",
					"civilian_bsp_01",
					"civilian_cogmind_01",
					"civilian_layout_bsp_01",
				},
				[6] = { 
					"civilian_01_open",
					"civilian_bsp_01",
					"civilian_cogmind_01",
					"civilian_layout_bsp_01",
				},
			},
			blueprint     = "level_callisto",
			rewards       = { 
				"lootbox_medical",
				{ "lootbox_armor", level = 2, },
				{ "medical_station", swap = 1, level = 4, },
			},
			lootbox_count = 3,
			intermission = {
				scene = "intermission_callisto",
				music = "music_callisto_intermission",
			},
		}
		data.level[1].blueprint = "level_callisto_intro"
		data.level[2].force_terminal = true
		data.level[4].blueprint = "level_callisto_hub"
		data.level[4].generator = "callisto_hub"
		data.level[4].special = world.add_special{
			episode        = 1,
			depth          = 4,
			generator      = "callisto_docks",
			blueprint      = "level_callisto_docks",
			ilevel_mod     = 2,
			dlevel_mod     = 1,
			branch_index   = 1,
			returnable     = true,
		}
		data.level[5].blueprint = "level_callisto_civilian"
		data.level[5].special = world.add_special{
			episode        = 1,
			depth          = 5,
			generator      = "callisto_military_barracks",
			blueprint      = "level_callisto_military",
			ilevel_mod     = 2,
			dlevel_mod     = 1,
			branch_index   = 1,
			returnable     = true,
		}
		data.level[6].blueprint = "level_callisto_civilian"		
		data.level[6].next      = 10007

		world.add_branch {
			name           = "Callisto Mines",
			episode        = 2,
			depth          = 7,
			size           = 3,
			enemy_list     = "callisto",
			enemy_mod      = { bot = 0, drone = 0.5, demon = 2, },
			blueprint      = "level_callisto_mines",
			lootbox_count  = 4,
			quest = {
				list   = "callisto",
				flavor = "mines",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "lootbox_armor" },
			},
			events     = {
				"event_desolation",
				"event_hunt",
				"event_infestation",
			},
			event      = { 100, math.random(3), },
			intermission = {
				scene = "intermission_callisto",
				music = "music_callisto_intermission",
			},		
		}
		data.level[9].special = world.add_special{
				episode        = 2,
				depth          = 9,
				generator      = "callisto_callisto_anomaly",
				blueprint      = "level_callisto_anomaly",
				ilevel_mod     = 2,
				dlevel_mod     = 1,
				branch_index   = 1,
				returnable     = true,
		}
		data.level[10].blueprint = "level_callisto_spaceport"
		data.level[10].generator = "callisto_spaceport"		
		data.level[10].next      = 10011

		local rift_data = {
			name           = "Callisto Rift",
			episode        = 1,
			depth          = 3,
			size           = 2,
			enemy_list     = "callisto",
			enemy_mod      = { bot = 0, drone = 0.5, demon = 2, },
			blueprint      = "level_callisto_rift",
			lootbox_count  = 4,
			quest = {
				list   = "callisto",
				flavor = "rift",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ { "lootbox_ammo", attach = "smoke_grenade" }, level = 2, },
				{ { "lootbox_general", attach = "enviropack" }, level = 1, },
				{ "lootbox_armor" },
			},
			events     = {
				{ "event_infestation", 3.0, },
				{ "event_hunt", 2.0, },
				"event_exalted_summons",
			},
			event      = { 100, math.random(3), },
			special = {
				generator  = "callisto_crevice",
				blueprint  = "level_callisto_crevice",
				ilevel_mod = 2,
				dlevel_mod = 1,
				returnable = true,
			},
			
		}

		local valhalla_data = {
			name           = "Valhalla Terminal",
			episode        = 1,
			depth          = 4,
			size           = 2,
			enemy_list     = "callisto",
			enemy_mod      = { demon2 = 0, civilian = 2, },
			blueprint      = "level_callisto_valhalla",
			item_mod       = { ammo_44 = 3, },
			lootbox_count  = 4,
			quest = {
				list = "callisto",
				flavor = "valhalla",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "lootbox_armor" },
			},
			events     = {
				--{ "event_volatile_storage", 2.0, },
				--{ "event_lockdown", 2.0, },
				"event_low_light", 
				"event_desolation",
				"event_infestation",
				"event_hunt",
			},
			event      = { 100, math.random(3), },
			special = {
				generator  = "callisto_valhalla_command",
				blueprint  = "level_callisto_command",
				ilevel_mod = 2,
				dlevel_mod = 1,
				returnable = true,
			},
		}

		local mimir_data = {
			name           = "Mimir Habitat",
			episode        = 1,
			depth          = 4,
			size           = 3,
			enemy_list     = "callisto",
			enemy_mod      = { demon1 = 0.3, demon2 = 0, },
			blueprint      = "level_callisto_mimir",
			item_mod       = { ammo_44 = 2, },
			lootbox_count  = 4,
			quest = {
				list = "callisto",
				flavor = "mimir",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "lootbox_armor" },
			},
			events     = {
				--{ "event_volatile_storage", 2.0, },
				{ "event_lockdown", 2.0, },
				"event_low_light",
				"event_infestation",
			},
			event      = { 100, math.random(3), },
			special = {
				generator      = "callisto_calsec_central",
				blueprint      = "level_callisto_calsec",
				ilevel_mod     = 2,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		world.add_branch {
			name       = "EUROPA",
			depth      = 11,
			episode    = 3,
			size       = 7,
			enemy_list = "europa",
			quest = {
				list = "europa",
			},
			generator = {
				[6] = { 
					"europa_ice_01",
					"europa_ice_02",
					"europa_ice_03",
				},
			},
			events     = {
				"event_low_light",
				{ "event_volatile_storage", 2.0, max_level = 3 },
				"event_infestation",
				"event_lockdown",
				"event_vault",
				"event_hunt",
				{ "event_windchill", 2.0 },
			},
			event      = { 100, math.random(4) + 1, },
			blueprint  = "level_europa",
			rewards    = { 
				"lootbox_medical",
				{ "manufacture_station", level = 1, },
				{ "medical_station", swap = 1, level = 4, },
				{ "technical_station", level = 2, },
				{ "terminal_ammo", level = 5, },
				{ "lootbox_armor", level = 4, },
			},
			lootbox_count = 3,
			intermission = {
				scene = "intermission_europa",
				music = "music_europa_intermission",
			},
		}
		data.level[11].blueprint = "level_europa_intro"
		data.level[12].force_terminal = true
		data.level[14].blueprint = "level_europa_concourse"
		data.level[15].blueprint = "level_europa_civilian"
		data.level[16].blueprint = "level_europa_ice"
		data.level[17].blueprint = "level_europa_central_dig"
		data.level[17].generator = "europa_central_dig"
		data.level[17].next      = 10018


		world.add_branch {
			name       = "IO",
			depth      = 18,
			episode    = 4,
			size       = 7,
			enemy_list = "io",
			quest = {
				list = "io",
			},
			enemy_mod  = {
				[5] = { cri = 0.5, demon = 1.5 },
				[6] = { cri = 0.5, demon = 1.5 },
			},
			generator = {
				[5] = { "io_deep_01", "io_deep_02", "io_deep_03", "io_deep_04", },
				[6] = { "io_deep_01", "io_deep_02", "io_deep_03", "io_deep_04", },
			},
			events     = {
				"event_low_light",
				{ "event_volatile_storage", 2.0, max_level = 3 },
				"event_infestation",
				"event_lockdown",
				"event_vault",
				"event_exalted_summons",
				"event_hunt",
				"event_contamination",
			},
			event      = { 100, math.random(4) + 1, },
			blueprint = "level_io",
			rewards   = { 
				"lootbox_medical",
				{ "medical_station", swap = 1, level = 4, },
				{ "technical_station", level = 1, },
				{ "lootbox_armor", level = 2, },
			},
			lootbox_count = 4,
			intermission = {
				scene = "intermission_io",
				music = "music_io_intermission",
			},
		}
		data.level[18].blueprint = "level_io_intro"
		data.level[19].force_terminal = true
		data.level[21].blueprint = "level_io_nexus"
		data.level[22].blueprint = "level_io_deep"
		data.level[23].blueprint = "level_io_deep"
		data.level[24].blueprint = "level_io_gateway"
		data.level[24].generator = "io_gateway_01"
		data.level[24].next      = 10025
	
		world.add_branch {
			name       = "BEYOND",
			depth      = 25,
			episode    = 5,
			size       = 4,
			quest = {
				no_info = true,
				list = "beyond",
			},
			enemy_mod  = {
				[3] = { bot = 0, former = 0 },
			},
			enemy_list = "beyond",
			generators = { "beyond_rocks_lava_01" },
			generator  = {
				[2] = { "beyond_rocks_lava_01", "beyond_rocks_01" },
				[3] = "beyond_pre_boss_01",
			},
			events     = {
				{ "event_exalted_summons", 3.0, },
				{ "event_hunt", 2.0, },
				"event_exalted_curse",
			},
			event      = { 100, math.random(2) + 1, },
			blueprint = "level_beyond",
			rewards       = { 
				"lootbox_medical",
				"lootbox_ammo",
				{ "terminal_ammo", swap = 2, level = 1, },
			},
			lootbox_count = 4,
			intermission = {
				scene     = "intermission_beyond",
				music     = "music_main_01",
			},
		}
		data.level[25].blueprint = "level_beyond_intro"
		data.level[25].generator = "beyond_intro"
		data.level[28].blueprint = "level_beyond_percipice"
		data.level[28].generator = "beyond_percipice"
		data.level[28].next      = 10029
		
		world.add_branch {
			name       = "Dante Station",
			depth      = 29,
			episode    = 6,
			size       = 4,
			quest = {
				no_info = true,
				list = "dante",
			},
			enemy_list = "dante",
			generators = { "dante_halls_01" },
			generator = {
				[2] = { "dante_halls_01" },
				[3] = { "dante_coliseum_01", },
			},
			events     = {
				{ "event_exalted_summons", 3.0, },
				{ "event_hunt", 2.0, },
			},
			event      = { DIFFICULTY*25, math.random(2) + 1, },
			blueprint = "level_dante",
			rewards       = { 
				"lootbox_medical",
				"lootbox_ammo",
			},
			lootbox_count = 4,
			intermission = {
				scene     = "intermission_dante",
				music     = "music_main_01",
				game_over = true,
			},
		}
		data.level[29].blueprint = "level_dante_intro"
		data.level[29].generator = "dante_intro"
		data.level[29].force_terminal = true
		data.level[29].lootbox_count  = 3
		data.level[32].blueprint = "level_dante_percipice"
		data.level[32].generator = "dante_percipice"
		data.level[32].blueprint = "level_dante_altar"
		data.level[32].generator = "dante_altar"

		local conamara_data = {
			name           = "Conamara Chaos Biolabs",
			episode        = 2,
			depth          = 0,
			size           = 2,
			enemy_list     = "europa",
			enemy_mod      = { demon = 2, cryo = 0.5 },
			blueprint      = "level_europa_biolabs",
			dlevel_mod     = 1,
			lootbox_count  = 4,
			quest = {
				list   = "europa",
				flavor = "conamara",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "lootbox_armor" },
			},
			events     = {
				"event_low_light",
				"event_volatile_storage",
				"event_infestation",
				"event_lockdown",
				"event_vault",
				"event_hunt",
				"event_exalted_summons",
				"event_contamination",
				{ "event_windchill", 2.0 },
			},
			event      = { 100, math.random(3), },
			special = {
				generator      = "europa_containment_area",
				blueprint      = "level_europa_containment",
				ilevel_mod     = 3,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		local dig_data = {
			name           = "Europa Dig Zone",
			episode        = 2,
			depth          = 0,
			size           = 3,
			enemy_list     = "europa",
			enemy_mod      = { demon = 2, },
			blueprint      = "level_europa_dig_zone",
			dlevel_mod     = 1,
			lootbox_count  = 4,
			quest = {
				list = "europa",
				flavor = "dig_zone",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "lootbox_armor" },
			},
			generators     = {
				"europa_caves_01",
				"europa_caves_02",
				"europa_caves_03",
			},
			events     = {
				{ "event_hunt",  3.0, },
				{ "event_exalted_summons", 2.0, },
				"event_vault",
				"event_exalted_curse",
			},
			event   = { 100, math.random(3), },
			special = {
				generator      = "europa_tyre_outpost",
				blueprint      = "level_europa_tyre",
				ilevel_mod     = 3,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		local asterius_data = {
			name           = "Asterius Habitat",
			episode        = 2,
			depth          = 0,
			size           = 3,
			enemy_list     = "europa",
			enemy_mod      = { demon = 0.5, demon2 = 0.5, civilian = 1.5, },
			blueprint      = "level_europa_asterius",
			dlevel_mod     = 1,
			lootbox_count  = 4,
			quest = {
				list   = "europa",
				flavor = "asterius",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "lootbox_armor" },
			},
			events     = {
				"event_low_light",
				"event_infestation",
				"event_lockdown",
				"event_hunt",
				"event_exalted_summons",
				"event_contamination",
				{ "event_windchill", 2.0 },
			},
			event   = { 100, math.random(3), },
			special = {
				generator      = "europa_asterius_breach",
				blueprint      = "level_europa_breach",
				ilevel_mod     = 3,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		local ruins_data = {
			name           = "Europa Ruins",
			episode        = 2,
			depth          = 0,
			size           = 2,
			enemy_list     = "europa",
			enemy_mod      = { cryo = 2, bot = 0.5 },
			blueprint      = "level_europa_ruins",
			dlevel_mod     = 1,
			lootbox_count  = 4,
			quest = {
				list = "europa",
				flavor = "ruins",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "lootbox_armor" },
			},
			events     = {
				{ "event_hunt",  3.0, },
				{ "event_exalted_summons", 2.0, },
				"event_vault",
				"event_exalted_curse",
				{ "event_windchill", 2.0 },
			},
			event   = { 100, math.random(3), },
			special = {
				blueprint      = "level_europa_temple",
				ilevel_mod     = 3,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		local europa_lists = {
			{ asterius_data, ruins_data, conamara_data },
			{ asterius_data, ruins_data, dig_data },
			{ conamara_data, ruins_data, dig_data },
			{ conamara_data, asterius_data, ruins_data, },
			{ asterius_data, dig_data, ruins_data, },
			{ conamara_data, dig_data, ruins_data, },
		}
		local europa_pick = europa_lists[math.random( #europa_lists )]
		early_branch = europa_pick[1]
		mid_branch   = europa_pick[2]
		late_branch  = europa_pick[3]

		early_branch.depth = 10
		mid_branch.depth   = 11
		late_branch.depth  = 12
		early_branch.size  = 3
		late_branch.size   = 2

		data.level[9].branch  = world.add_branch( early_branch )
		data.level[10].branch = world.add_branch( mid_branch )
		data.level[11].branch = world.add_branch( late_branch )

		local blacksite_data = {
			name           = "Io Black Site",
			episode        = 3,
			depth          = 0,
			size           = 2,
			enemy_list     = "beyond",
			enemy_mod      = { former = 2, },
			blueprint      = "level_io_blacksite",
			dlevel_mod     = 1,
			lootbox_count  = 5,
			quest = {
				list = "io",
				flavor = "blacksite",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
			},
			events     = {
				"event_volatile_storage",
				"event_infestation",
				"event_vault",
				"event_exalted_summons",
				"event_exalted_curse",
				"event_contamination",
				{ "event_desolation", 2.0 },
			},
			event   = { 100, math.random(3), },
			special = {
				blueprint      = "level_io_vault",
				ilevel_mod     = 3,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		local crilab_data = {
			name           = "CRI Laboratory",
			episode        = 3,
			depth          = 0,
			size           = 2,
			enemy_list     = "cri",
			blueprint      = "level_io_cri_labs",
			dlevel_mod     = 1,
			lootbox_count  = 5,
			quest = {
				list = "io",
				flavor = "laboratory",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
			},
			events     = {
				"event_low_light",
				"event_vault",
				"event_exalted_summons",
			},
			event   = { 100, math.random(3), },
			special = {
				blueprint      = "level_io_armory",
				ilevel_mod     = 3,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		local nox_data = {
			name           = "Mephitic Mines",
			episode        = 3,
			depth          = 0,
			size           = 2,
			enemy_list     = "io",
			blueprint      = "level_io_mephitic",
			enemy_mod      = { cri = 0.0, toxic = 4.0, },
			dlevel_mod     = 1,
			lootbox_count  = 5,
			quest = {
				list = "io",
				flavor = "mephitic",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "terminal_ammo", level = 2, },
			},
			events     = {
				"event_exalted_summons",
				{ "event_hunt", 2.0 },
				"event_exalted_curse",
			},
			event   = { 100, math.random(3), },
			special = {
				generator      = "io_noxious",
				blueprint      = "level_io_noxious",
				ilevel_mod     = 3,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		local halls_data = {
			name           = "Shadow Halls",
			episode        = 3,
			depth          = 0,
			size           = 3,
			enemy_list     = "io",
			enemy_mod      = { former = 0.5, bot = 0.5, cri = 0 },
			blueprint      = "level_io_halls",
			dlevel_mod     = 1,
			lootbox_count  = 5,
			quest = {
				list = "io",
				flavor = "halls",
			},
			rewards        = {
				"lootbox_medical",
				{ "medical_station", swap = 1, },
				{ "terminal_ammo", level = 2, },
			},
			events     = {
				"event_low_light",
				"event_volatile_storage",
				"event_infestation",
				"event_vault",
				"event_exalted_summons",
				"event_hunt",
				"event_exalted_curse",
			},
			event   = { 100, math.random(3), },
			special = {
				blueprint      = "level_io_cathedral",
				ilevel_mod     = 3,
				dlevel_mod     = 1,
				returnable     = true,
			},
		}

		local io_pick = { blacksite_data, crilab_data, nox_data }
		-- remove one, add ruins
		table.remove( io_pick, math.random( #io_pick ) ) 
		io_pick[3] = halls_data

		early_branch  = table.remove( io_pick, math.random( #io_pick ) ) 
		mid_branch    = table.remove( io_pick, math.random( #io_pick ) ) 
		late_branch   = table.remove( io_pick, math.random( #io_pick ) ) 

		early_branch.depth = 17
		mid_branch.depth   = 18
		late_branch.depth  = 19
		early_branch.size  = 3
		late_branch.size   = 2

		data.level[16].branch = world.add_branch( early_branch )
		data.level[17].branch = world.add_branch( mid_branch )
		data.level[18].branch = world.add_branch( late_branch )

		

		local level_12 = { nil, "level_europa_refueling" }
		if math.random(2) ~= 1 then
			level_12 = { "europa_pit", "level_europa_pit" }
		end

		data.level[12].special = world.add_special{
			episode        = 2,
			depth          = 12,
			generator      = level_12[1],
			blueprint      = level_12[2],
			ilevel_mod     = 3,
			dlevel_mod     = 1,
			branch_index   = 2,
			returnable     = true,
		}

		local level_19 = "level_io_warehouse"
		if math.random(2) > 1 then
			level_19 = "level_io_lock"
		end

		data.level[19].special = world.add_special{
			episode        = 3,
			depth          = 19,
			blueprint      = level_19,
			ilevel_mod     = 3,
			dlevel_mod     = 1,
			branch_index   = 3,
			returnable     = true,
		}

		data.level[22].special = world.add_special{
			episode        = 4,
			depth          = 22,
			next           = 23,
			generator      = "beyond_crucible",
			blueprint      = "level_beyond_crucible",
			ilevel_mod     = 3,
			dlevel_mod     = 1,
			branch_index   = 4,
		}
		data.level[22].special_hidden = true

		data.level[23].special = world.add_special{
			episode        = 4,
			depth          = 23,
			generator      = "dante_inferno",
			blueprint      = "level_dante_inferno",
			ilevel_mod     = 3,
			dlevel_mod     = 1,
			branch_index   = 4,
		}

		for _,linfo in ipairs( data.level ) do
			linfo.lootbox_count = linfo.lootbox_count or 0
			linfo.rewards       = linfo.rewards or {}
			if linfo.lootbox_count > 0 then
				if DIFFICULTY == 0 then
					linfo.lootbox_count = linfo.lootbox_count + 1 
				elseif DIFFICULTY == 1 then
					if math.random( 100 ) > 33 then
						linfo.lootbox_count = linfo.lootbox_count + 1 
					end
				end
			end

			assert( linfo.blueprint )
			if blueprints[linfo.blueprint].text then
				local name = blueprints[linfo.blueprint].text.name
				if type( name ) == "string" then
					linfo.name = name
				end
			end
			linfo.name = linfo.name or ""
		end
		world.data.special_levels = 8

		local roll = math.random(100)
		if roll <= 20 then
			world.data.unique.guaranteed = 1
		elseif roll <= 60 then
			world.data.unique.guaranteed = 2
		else
			world.data.unique.guaranteed = 3
		end
	end,
	on_setup = function( )
		if DIFFICULTY == 0 then
			core.global_mod.vhard = 0.0
			core.global_mod.hard  = 0.5
		elseif DIFFICULTY == 1 then
			core.global_mod.vhard = 0.5
			core.global_mod.hard  = 0.5
		end
	end,
	on_next = function( next )
		return world.next( next )
	end,
	on_load = function( player )
		world.initialize()
		world.set_klass( gtk.get_klass_id( player ) )
	end,
	on_init = function( player )
		world.set_klass( gtk.get_klass_id( player ) )

		player.statistics.data.special_levels.generated  = world.data.special_levels
		player.statistics.data.special_levels.accessible = world.data.special_levels

		-- generate quests
		local quest_used = {}
		
		for _,b in ipairs( world.data.branch ) do
			if b.quest and b.quest.list and not b.quest.no_info then
				local ilist = core.lists.quest_info[b.quest.list]
				local slist = core.lists.quest_short[b.quest.list]
				if ilist then
					local target
					local source
					if #b.index <= 3 then
						target  = b.index[ math.random( math.min( #b.index, 2 ) ) ]
						local entry   = b.index[1]
						local pbranch = world.data.branch[ b.prev_branch ]
						local epoint 
						for idx,id in ipairs( pbranch.index ) do
							if world.data.level[id].branch == entry then
								epoint = idx
								break
							end
						end
						local pos = 1 + math.random( epoint - 1 )
						source = pbranch.index[ pos ]
					else
						target  = b.index[2 + math.random( 3 )]
						source  = b.index[2]
					end
					local sid
					local short = true
					if #b.index < 3 and math.random(2) == 1 then
						short = false
					end
					if short then
						if #b.index < 3 then
							target = b.index[1]
						elseif #b.index > 3 then
							target = b.index[6]
						end
						sid = slist:roll( world.data.level[target].depth, quest_used, true )
					end
					if not sid then
						sid = ilist:roll( world.data.level[target].depth, quest_used, true )
					end
					quest_used[sid] = 0
					local idx = world:add_quest( player, world:create_entity( sid, target ) )
					table.insert( world.data.level[source].quest, idx )
				end
			end
		end
	end,
	on_end   = function( player, result )
		if result > 0 then
			ui:alert{
				delay = 3000,
				position = ivec2( -1, 18 ),
				size = ivec2( 30, 6 ),
				content = "     {R"..ui:text("ui.lua.common.connection_lost").."}\n "..ui:text("ui.lua.common.continue"),
				footer = " ",
				win = true,
			}
			world:lua_callback( player, "on_win_game" )
			world:play_voice( "vo_beyond_ending" )
		elseif result == 0 then
			ui:post_mortem( result, true )
			ui:dead_alert()
		elseif result < 0 then
			ui:post_mortem( result, true )
		end
	end,
	on_stats = function( player, win )		
		if win then
			return
		end
	end,
	on_entity = function( entity )
		world.on_entity( entity )
	end,
}
