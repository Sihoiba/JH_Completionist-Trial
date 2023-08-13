nova.require "trial_gfx/entities_gfx.lua"
nova.require "trial_data/entities.lua"

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

register_world "trial_completionist"
{
	on_create = function( seed )
		local data = world.setup( seed )
		data.cot = {}
		world.add_branch {
			name       = "CALLISTO",
			depth      = 1,
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
		data.level[1].blueprint = "level_callisto_intro"
				
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
