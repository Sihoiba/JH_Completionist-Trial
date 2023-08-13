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
		score = false,
    },
    callbacks = {
        on_create_player = [[
            function( self, player )                
				player:attach( "shotgun" )
                player:attach( "ammo_shells", { stack = { amount = 30 } } )		
            end
        ]],
    },
}

register_blueprint "level_callisto_enemy_test"
{
    blueprint   = "level_base",
	text        = {
        name        = "CALLISTO L1",
        on_enter    = "You come back from a routine patrol of the Callisto orbit. Your landing craft gets shot down by the automated defense systems. Something is wrong...",
    },
    environment = {
        music        = "music_callisto_01",
    },
    attributes = {
        xp_check = 0,
    },
    callbacks = {
        on_create = [[
            function ( self )

                local generate = function( self, params )
                    local tiles  = { callisto_intro_13x13, callisto_intro_13x13, callisto_intro_11x13, callisto_intro_13x13_2, callisto_intro_9x7 }
                    local set    = tiles[ math.random(#tiles) ]
                    self:resize( set.map_size )
                    self:set_styles{ "ts06_F:ext", "ts06_F:hangar", "ts06_F", "ts06_F:pipes",  }
            
                    local result  = generator.archibald( self, set )
                    local rewards = {
                        { "lootbox_medical", "lootbox_ammo", "lootbox_general" },
                        { "lootbox_medical", "lootbox_ammo", "lootbox_general" },
                        { "lootbox_medical", "lootbox_ammo" },
                        { "lootbox_medical", "lootbox_ammo" },
                        { "lootbox_medical", "lootbox_ammo", "lootbox_armor" },
                    }
                    local list = rewards[ math.min( DIFFICULTY + 1, #rewards )]  
                    generator.drop_marker_rewards( self, "mark_special", larea, list )
                    result.no_elevator_check = true
                    for c in self:get_area():edges() do
                        self:set_cell_flag( c, EF_NOSPAWN, true )
                    end
                    return result
                end
            
                local spawn = function( self )
                    local enemies = {
                        -- EASY:
                        { "medusaling", "medusaling", "medusaling", "medusaling", "medusaling", "medusaling" },
                        -- MEDIUM:
                        { "medusaling", "medusaling", "medusaling", "medusaling", "medusaling", "archmedusaling" },
                        -- HARD:
                        { "medusaling", "medusaling", "medusaling", "archmedusaling", "archmedusaling", "archmedusaling" },
                        -- UV, N!
                        { "medusaling", "medusaling", "archmedusaling", "archmedusaling", "archmedusaling", "archmedusaling" },
						}
                    local list        = enemies[ math.min( DIFFICULTY + 1, #enemies )]  
                    local entry_coord = self:find_coord( "floor_entrance" ) or ivec2(1,1)
            
                    for _,v in ipairs( list ) do
                        local p = generator.random_safe_spawn_coord( self, self:get_area():shrinked(4), entry_coord, 7 )
                        local result = generator.spawn( self, v, p )
                    end
                end

                generator.run( self, nil, generate, spawn )
                self.environment.lut = math.random_pick( luts.standard )
            end
            ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
                local vo = "vo_callisto"
                if DIFFICULTY > 1 and math.random(10) == 1 then
                    if math.random(10) == 1 then
                        vo = "vo_callisto_rare"
                    else
                        vo = "vo_callisto_cool"
                    end
                end
                ui:alert {
                    title   = "",
                    teletype = 0,
                    content = self.text.on_enter,
                    size    = ivec2( 34, 10 ),
                }
                world:play_voice( vo )
            end
        ]],
        on_kill = [[
            function ( self, killed, killer, all )
                if self.attributes.xp_check == 1 then
                    local expected = { 200, 220, 300, 400 }
                    local min_xp   = expected[math.min( DIFFICULTY + 1, #expected )]
                    local player   = world:get_player()
                    if player.progression and player.progression.experience < min_xp then
                        local bonus = min_xp - player.progression.experience
                        world:add_experience( player, bonus )
                    end
                    self.attributes.xp_check = 0
                end
            end
        ]],
        on_cleared = [[
            function ( self )
                self.attributes.xp_check = 1
            end
        ]],
    }
}

register_world "trial_completionist"
{
	on_create = function( seed )
		local data = world.setup( seed )
		data.cot = {}
		world.add_branch {
			name       = "CALLISTO",
			depth      = 2,
			episode    = 1,
			size       = 1,
			enemy_list = "enemy_test",
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
			},
			lootbox_count = 3,
			intermission = {
				scene = "intermission_callisto",
				music = "music_callisto_intermission",
			},
		}
		data.level[1].blueprint = "level_callisto_enemy_test"
				
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
		world.data.special_levels = 0
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
		world.set_klass( player.text.klass )
	end,
	on_init = function( player )
		world.set_klass( player.text.klass )

		player.statistics.data.special_levels.generated  = world.data.special_levels
		player.statistics.data.special_levels.accessible = 4

		if world.data.no_quests then return end
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
		diff.on_entity( entity )
	end,
}
