nova.require "data/lua/jh/main"

register_blueprint "elevator_inactive_completionist"
{
    text = {
        short = "inactive",
        failure = "A completionist has to visit the ",
    },
    callbacks = {
        on_activate = [=[
            function( self, who, level )
                if who == world:get_player() then
                    local exitType = "branch"
                    if world.data.level[ world.data.current ].special then
                        exitType = "special level"
                    end
                    ui:set_hint( self.text.failure..exitType.."!", 2001, 0 )
                    world:play_voice( "vo_refuse" )
                end
                return 1
            end
        ]=],
        on_attach = [=[
            function( self, parent )
                parent.flags.data =  { EF_NOSIGHT, EF_NOMOVE, EF_NOFLY, EF_NOSHOOT, EF_BUMPACTION, EF_ACTION }
            end
        ]=],
        on_detach = [=[
            function( self, parent )
                parent.flags.data =  {}
            end
        ]=],
    },
}

register_blueprint "level_beyond_intro_completionist"
{
    blueprint   = "level_base",
    text = {
        name        = "BEYOND L1",
        on_enter    = "You feel yanked in a nondescript direction. You don't think you're on Io anymore...",
        on_portal   = "You aren't finished yet...",
    },
    level_info  = {
        low_light = true,
        light_range = 4,
    },
    attributes  = {
        portal      = 0,
    },
    level_vo = {
        silly   = 0.0,
        serious = 1.0,
    },
    environment = {
        lut          = "lut_01_base",
        music        = "music_beyond_01",
        volumetric   = -0.65,
        hdr_exposure = 2.4,
    },
    callbacks = {
        on_create = [[
            function ( self )
                generator.run( self )
            end
            ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end                
                ui:alert {
                    title   = "",
                    teletype = 0,
                    content = self.text.on_enter,
                    size    = ivec2( 34, 8 ),
                }
                local vo = "vo_beyond"
                if DIFFICULTY > 2 then
                    vo = "vo_beyond_cool"
                elseif DIFFICULTY == 2 and math.random(3) == 1 then
                    vo = "vo_beyond_cool"
                elseif DIFFICULTY == 1 and math.random(10) == 1 then
                    vo = "vo_beyond_cool"
                end
                world:play_voice( vo )
            end
        ]],       
    }
}

register_blueprint "level_beyond_percipice_completionist"
{
    blueprint  = "level_base",
    text       = {
        name   = "Precipice of Defeat",
    },
    attributes  = {
        portal      = 0,
    },
    ui_boss    = {},
    environment = {
        lut          = "lut_07_yellowish",
        music        = "music_beyond_04",
    },
    level_vo = {
        silly   = 0.0,
        serious = 1.0,
    },
    callbacks = {
        on_create = [[
            function ( self )
                world.data.dante_altar = world.data.dante_altar or {}
                world.data.dante_altar.marks = {}
                generator.run( self )               
            end
        ]],     
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
                world:play_voice( "vo_beyond_boss" )
            end
        ]],
        is_cleared = [[
            function ( self )
                if self.level_info.enemies > 2 then return 0 end                
                return 1
            end
        ]],
        on_kill = [[
            function ( self, killed, killer, all )              
                if self.attributes.portal == 0 and killed.data.boss then                                      
                    local e = self:place_entity( "portal_01", self:find_coord( "portal_off" ) )                    
                    ui:spawn_fx( nil, "fx_summon_exalted", nil, world:get_position( e ) )           
                end
                if self.level_info.enemies == 2 then 
                    self.level_info.cleared = true
                    nova.log("Beyond precipice cleared")
                end
            end
        ]],
    }
}

register_generator "beyond_percipice_completionist"
{
    generate = function(self)
        self:resize( ivec2( 70, 30 ) )
        self:set_styles{ "ts09_A:runes" }
        generator.fill( self, "gap" )
        local larea = self:get_area():shrinked(7)

        local boss_tile =
        {
            translation = {
                ["#"] = "wall",
                ["."] = "gap",
                [","] = "floor",
                ["K"] = "marker3",
                ["'"] = { "floor", "ceiling_light_high_01_A", placement = "ceiling", },
                ["S"] = { "floor", "ceiling_light_high_01_A", "summoner_c", placement = "ceiling", },
                ["!"] = { "elevator_off", "elevator_01_off", placement = "floor", },
                ["M"] = { "floor", "medkit_large" },
                ["A"] = { "floor", "armor_blue" },
                ["P"] = { "portal_off", "portal_01_off" },
            },
            map =
        [[
..............................................,,,,,,....
...............................,,,,,,........,,,,,,,,...
...................,,,.......,,,,,,,,,,......,,#,,,,,,..
..,,,............,,,,,,,.....,,,#,,#,,,,......,',,#,,,,.
,,,M,,,.........,,',#,',,...,,',,,,,,',,,.....,,,,,,',,,
,,,',,,,,......,,#,,,,,#,,..,#,,,,,,,,#,,.....,,,K,,,#,,
,,,,,,'#,,,,,,,,,,K,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
',P,,,,,,,,',,,,,,,,S,,,,,',,,,,,,,,,,,,,,,',,,,',,,,,',
,,,,,,'#,,,,,,,,,,K,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,',,,,,,.....,,#,,,,,#,...,#,,,,,,,,#,,....,,,,K,,,#,,
.,,A,,..........,,',#,',,...,,',,,,,,',,,.....,,,,,,',,,
...,,............,,,,,,,.....,,,#,,#,,,,......,',,#,,,,.
...................,,,........,,,,,,,,,......,,#,,,,,,..
...............................,,,,,,........,,,,,,,,...
..............................................,,,,,,....
        ]],
        }
        if world.data.exalted_boss or DIFFICULTY > 3 then boss_tile.translation["S"][3] = "exalted_summoner_c" end
        local tile  = map_tile.new( boss_tile.map, boss_tile.translation, self ) 
        tile:flip_xy()
        tile:place( self, larea.a, generator.placer, self )
        for c in self:coords( "marker3" ) do
            self:set_cell( c, "floor" )
            table.insert( world.data.dante_altar.marks, c:clone() )
        end
        return { area = larea, no_elevator_check = true }
    end,
    
    spawn_enemies = function( self )
        generator.spawn_enemies( self, 10000, {
            list       = core.lists.being.beyond, 
            mod        = { bot = 0, drone = 0, former = 0 },
            level      = 28,
            safe       = "portal_off",
            safe_range = 7,
        })
    end,
}

register_blueprint "level_dante_intro_completionist"
{
    blueprint   = "level_base",
    text = {
        name        = "Dante Vestibule",
        on_enter    = "You feel yanked in a nondescript direction. You are hell knows where...",
    },
    level_info  = {
        low_light = true,
        light_range = 4,
    },
    attributes  = {
        portal      = 0,
    },
    level_vo = {
        silly   = 0.0,
        serious = 1.0,
    },
    environment = {
        lut          = "lut_01_base",
        music        = "music_beyond_01",
        volumetric   = -0.65,
        hdr_exposure = 2.4,
    },
    callbacks = {
        on_create = [[
            function ( self )
                generator.run( self )
            end
            ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
                ui:alert {
                    title   = "",
                    teletype = 0,
                    content = self.text.on_enter,
                    size    = ivec2( 34, 8 ),
                }
                local vo = "vo_beyond"
                if DIFFICULTY > 2 then
                    vo = "vo_beyond_cool"
                elseif DIFFICULTY == 2 and math.random(3) == 1 then
                    vo = "vo_beyond_cool"
                elseif DIFFICULTY == 1 and math.random(10) == 1 then
                    vo = "vo_beyond_cool"
                end
                world:play_voice( vo )
            end
        ]],        
    }
}

register_blueprint "runtime_completionist"
{
    flags = { EF_NOPICKUP },
    callbacks = {       
        on_enter_level = [[
            function ( self, player, reenter )
                nova.log("Level: "..world:get_level().text.name.." depth: "..tostring(world:get_level().level_info.depth).." reenter "..tostring(reenter))
                
                if world.data.current == 89 then
                    world:mark_destroy(generator.find_entity_id( world:get_level(), "cot_exit_n" ))
                    world:mark_destroy(generator.find_entity_id( world:get_level(), "cot_plate_n" ))
                    world:mark_destroy(generator.find_entity_id( world:get_level(), "cot_exit_e" ))
                    world:mark_destroy(generator.find_entity_id( world:get_level(), "cot_plate_e" ))
                    world:mark_destroy(generator.find_entity_id( world:get_level(), "cot_exit_s" ))
                    world:mark_destroy(generator.find_entity_id( world:get_level(), "cot_plate_s" ))
                    world:mark_destroy(generator.find_entity_id( world:get_level(), "cot_exit_w" ))
                    world:mark_destroy(generator.find_entity_id( world:get_level(), "cot_plate_w" ))
                    if reenter then
                        world:play_voice( "vo_refuse" )
                    else    
                        world:play_voice( "vo_fast_leave" )
                    end 
                elseif reenter then
                    local inactive_elevator
                    local not_return_mini = true
                    nova.log("Completionist returning")
                    for e in world:get_level():entities() do
                        if world:get_id( e ) == "elevator_01" then   
                            nova.log("Found elevator_01")                       
                            inactive_elevator = e:child( "elevator_inactive_completionist" )
                        elseif world:get_id( e ) == "elevator_01_mini" and world:get_position(player) == world:get_position(e) then 
                            nova.log("Returned via mini level")
                            not_return_mini = false
                        end
                        if world:get_id( e ) == "elevator_01_mini" then
                            nova.log("Returned and mini level exit exists")
                        end 
                    end 
                    if inactive_elevator and not_return_mini then
                        nova.log("Elevator unlocked after return")
                        world:mark_destroy( inactive_elevator )
                    end
                else
					if world.data.current == world.data.cal_guaranteed_unique then
						nova.log("Unique guaranteed on next Callisto special encountered")
						world.data.unique.guaranteed = 1
					elseif world.data.current == world.data.eur_guaranteed_unique then
						nova.log("Unique guaranteed on next Europa special encountered")
						world.data.unique.guaranteed = 2
					elseif world.data.current == world.data.io_guaranteed_unique then
						nova.log("Unique guaranteed on next Io special encountered")
						world.data.unique.guaranteed = 3
					end
                    local unlocked = {1,9,17,25,26,27,29,31,33,34,37,38,41,42,45,46,49,50,53,54,57,58,61,62,65,66,69,70,73,74,77,78,88}
                    local do_lock = true
                    for index, level in ipairs(unlocked) do                 
                        if level == world.data.current then  
                            do_lock = false
                        end
                    end             
                    if do_lock then     
                        for e in world:get_level():entities() do
                            if world:get_id( e ) == "elevator_01" then                              
                                e:equip("elevator_inactive_completionist")            
                            end
                        end         
                    end
                end
            end
        ]]  
    },
}

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
    flags = { EF_NOPICKUP },
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
        name        = "Completionist",
        desc        = "{!COMPLETIONIST MOD}\nYou not going to rest until have seen every last part of every single base accross Jupiter and its moons.\n\n You will visit every single floor, every branch (all four!) and every special level (every single one!) on every moon.\nIn order to ensure you do normal elevators are locked when a branch exit is available, and Callisto, Europa and IO each have an extra floor to fit everything in.\n\nReccommended to install the additional enemy mods to keep the variety more interesting and the threats more than just load and load of medusae!",
        abbr        = "Comp",
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
                -- player:attach( "runtime_murder" )
                player:attach( "runtime_completionist" )
                player:attach( "keycard_red", { stack = { amount = 3 } } )
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
            size       = 8,
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
                [7] = { 
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
        data.level[3].depth = 6
        data.level[4].blueprint = "level_callisto_hub"
        data.level[4].generator = "callisto_hub"
        data.level[4].depth = 10
        data.level[5].blueprint = "level_callisto_civilian"
        data.level[5].depth = 14
        data.level[6].blueprint = "level_callisto_civilian"
        data.level[6].depth = 18
        data.level[7].blueprint = "level_callisto_civilian"
        data.level[7].depth = 19
        data.level[8].blueprint = "level_callisto_spaceport"
        data.level[8].generator = "callisto_spaceport"
        data.level[8].depth = 20
        data.level[8].next      = 10009

        world.add_branch {
            name       = "EUROPA",
            depth      = 21,
            episode    = 2,
            size       = 8,
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
                [7] = { 
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
        data.level[9].blueprint = "level_europa_intro"      
        data.level[10].force_terminal = true
        data.level[10].depth = 22
        data.level[11].depth = 26
        data.level[12].blueprint = "level_europa_concourse"
        data.level[12].depth = 30
        data.level[13].blueprint = "level_europa_civilian"
        data.level[13].depth = 34
        data.level[14].blueprint = "level_europa_ice"
        data.level[14].depth = 38
        data.level[15].blueprint = "level_europa_ice"
        data.level[15].depth = 39
        data.level[16].blueprint = "level_europa_central_dig"
        data.level[16].generator = "europa_central_dig"
        data.level[16].depth = 40
        data.level[16].next      = 10017


        world.add_branch {
            name       = "IO",
            depth      = 41,
            episode    = 3,
            size       = 8,
            enemy_list = "io",
            quest = {
                list = "io",
            },
            enemy_mod  = {
                [5] = { cri = 0.5, demon = 1.5 },
                [6] = { cri = 0.5, demon = 1.5 },
                [7] = { cri = 0.5, demon = 1.5 },
            },
            generator = {
                [5] = { "io_deep_01", "io_deep_02", "io_deep_03", "io_deep_04", },
                [6] = { "io_deep_01", "io_deep_02", "io_deep_03", "io_deep_04", },
                [7] = { "io_deep_01", "io_deep_02", "io_deep_03", "io_deep_04", },
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
        data.level[17].blueprint = "level_io_intro"
        data.level[18].force_terminal = true
        data.level[18].depth = 42
        data.level[19].depth = 46
        data.level[20].blueprint = "level_io_nexus"
        data.level[20].depth = 50
        data.level[21].blueprint = "level_io_deep"
        data.level[21].depth = 54
        data.level[22].blueprint = "level_io_deep"
        data.level[22].depth = 58
        data.level[23].blueprint = "level_io_deep"
        data.level[23].depth = 59
        data.level[24].blueprint = "level_io_gateway"
        data.level[24].generator = "io_gateway_01"
        data.level[24].depth = 60
        data.level[24].next      = 10025

        world.add_branch {
            name       = "BEYOND",
            depth      = 61,
            episode    = 4,
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
        data.level[25].blueprint = "level_beyond_intro_completionist"
        data.level[25].generator = "beyond_intro"
        data.level[26].depth = 62
        data.level[27].depth = 63       
        data.level[28].blueprint = "level_beyond_percipice_completionist"
        data.level[28].generator = "beyond_percipice_completionist"
        data.level[28].depth = 64
        data.level[28].next      = 10029

        world.add_branch {
            name       = "Dante Station",
            depth      = 65,
            episode    = 5,
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
        data.level[29].blueprint = "level_dante_intro_completionist"
        data.level[29].generator = "dante_intro"
        data.level[29].force_terminal = true
        data.level[29].lootbox_count  = 3
        data.level[30].depth = 66
        data.level[31].depth = 67
        data.level[32].blueprint = "level_dante_altar"
        data.level[32].generator = "dante_altar"
        data.level[32].depth = 68
        data.cot.boss_index = 32

        local mines_data = {
            name           = "Callisto Mines",
            episode        = 1,
            depth          = 3,
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
            special = {
                generator      = "callisto_callisto_anomaly",
                blueprint      = "level_callisto_anomaly",
                ilevel_mod     = 2,
                dlevel_mod     = 1,
                returnable     = true,
            },
        }

        local rift_data = {
            name           = "Callisto Rift",
            episode        = 1,
            depth          = 3,
            size           = 3,
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
            size           = 3,
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

        local call_early_branch 
        local call_mid_branch 
        local call_late_branch
        local call_final_branch

        local remain = { mines_data, valhalla_data, rift_data, mimir_data }
        call_early_branch = table.remove( remain, math.random( #remain ) ) 
        call_early_branch.size = 3
        call_early_branch.depth = 3
        
        call_mid_branch = table.remove( remain, math.random( #remain ) ) 
        call_mid_branch.size   = 3
        call_mid_branch.depth   = 7
        
        call_late_branch = table.remove( remain, math.random( #remain ) ) 
        call_late_branch.size   = 3
        call_late_branch.depth  = 11

        call_final_branch = table.remove( remain, math.random( #remain ) )      
        call_final_branch.size   = 3
        call_final_branch.depth  = 15

        data.level[2].branch = world.add_branch( call_early_branch )
        data.level[35].next = 3
        data.level[3].branch = world.add_branch( call_mid_branch )
        data.level[39].next = 4
        data.level[4].branch = world.add_branch( call_late_branch )
        data.level[43].next = 5
        data.level[5].branch = world.add_branch( call_final_branch )
        data.level[47].next = 6

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
        
        local eur_early_branch 
        local eur_mid_branch 
        local eur_late_branch
        local eur_final_branch

        local remain = { asterius_data, ruins_data, conamara_data, dig_data }
        eur_early_branch = table.remove( remain, math.random( #remain ) ) 
        eur_early_branch.size = 3
        eur_early_branch.depth = 23
        
        eur_mid_branch = table.remove( remain, math.random( #remain ) ) 
        eur_mid_branch.size   = 3
        eur_mid_branch.depth   = 27
        
        eur_late_branch = table.remove( remain, math.random( #remain ) ) 
        eur_late_branch.size   = 3
        eur_late_branch.depth  = 31

        eur_final_branch = table.remove( remain, math.random( #remain ) )       
        eur_final_branch.size   = 3
        eur_final_branch.depth  = 35

        data.level[10].branch = world.add_branch( eur_early_branch )
        data.level[51].next = 11
        data.level[11].branch = world.add_branch( eur_mid_branch )
        data.level[55].next = 12
        data.level[12].branch = world.add_branch( eur_late_branch )
        data.level[59].next = 13
        data.level[13].branch = world.add_branch( eur_final_branch )
        data.level[63].next = 14

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
        
        local io_early_branch 
        local io_mid_branch 
        local io_late_branch
        local io_final_branch

        local remain = { blacksite_data, crilab_data, nox_data, halls_data }
        io_early_branch = table.remove( remain, math.random( #remain ) ) 
        io_early_branch.size = 3
        io_early_branch.depth = 43
        
        io_mid_branch = table.remove( remain, math.random( #remain ) ) 
        io_mid_branch.size   = 3
        io_mid_branch.depth   = 47
        
        io_late_branch = table.remove( remain, math.random( #remain ) ) 
        io_late_branch.size   = 3
        io_late_branch.depth  = 51

        io_final_branch = table.remove( remain, math.random( #remain ) )        
        io_final_branch.size   = 3
        io_final_branch.depth  = 55

        data.level[18].branch = world.add_branch( io_early_branch )
        data.level[67].next = 19
        data.level[19].branch = world.add_branch( io_mid_branch )
        data.level[71].next = 20
        data.level[20].branch = world.add_branch( io_late_branch )
        data.level[75].next = 21
        data.level[21].branch = world.add_branch( io_final_branch )
        data.level[79].next = 22

        local level_6 = { "callisto_docks", "level_callisto_docks" }
        local level_7 = { "callisto_military_barracks", "level_callisto_military" }
        if math.random(2) == 1 then
            level_6 = { "callisto_military_barracks", "level_callisto_military" }
            level_7 = { "callisto_docks", "level_callisto_docks" }
        end
        data.level[6].special = world.add_special{
            episode        = 1,
            depth          = 18,
            prev           = 6,
            generator      = level_6[1],
            blueprint      = level_6[2],
            ilevel_mod     = 2,
            dlevel_mod     = 1,
            branch_index   = 1,
            returnable     = true,
        }
        data.level[7].special = world.add_special{
            episode        = 1,
            depth          = 19,
            prev           = 7,
            generator      = level_7[1],
            blueprint      = level_7[2],
            ilevel_mod     = 2,
            dlevel_mod     = 1,
            branch_index   = 1,
            returnable     = true,
        }

        local level_14 = { nil, "level_europa_refueling" }
        local level_15 = { "europa_pit", "level_europa_pit" }
        if math.random(2) ~= 1 then
            level_14 = { "europa_pit", "level_europa_pit" }
            level_15 = { nil, "level_europa_refueling" }
        end

        data.level[14].special = world.add_special{
            episode        = 2,
            depth          = 38,            
            prev           = 14,
            generator      = level_14[1],
            blueprint      = level_14[2],
            ilevel_mod     = 3,
            dlevel_mod     = 1,
            branch_index   = 2,
            returnable     = true,
        }
        data.level[15].special = world.add_special{
            episode        = 2,
            depth          = 39,
            prev           = 15,
            generator      = level_15[1],
            blueprint      = level_15[2],
            ilevel_mod     = 3,
            dlevel_mod     = 1,
            branch_index   = 2,
            returnable     = true,
        }

        local level_22 = "level_io_warehouse"
        local level_23 = "level_io_lock"
        if math.random(2) > 1 then
            level_22 = "level_io_lock"
            level_23 = "level_io_warehouse"
        end

        data.level[22].special = world.add_special{
            episode        = 3,
            depth          = 58,
            prev           = 22,
            blueprint      = level_22,
            ilevel_mod     = 3,
            dlevel_mod     = 1,
            branch_index   = 3,
            returnable     = true,
        }
        data.level[23].special = world.add_special{
            episode        = 3,
            depth          = 59,
            prev           = 23,
            blueprint      = level_23,
            ilevel_mod     = 3,
            dlevel_mod     = 1,
            branch_index   = 3,
            returnable     = true,
        }

        data.level[28].special = world.add_special{
            episode        = 4,
            depth          = 64,
            next           = 10029,
            generator      = "beyond_crucible",
            blueprint      = "level_beyond_crucible",
            ilevel_mod     = 3,
            dlevel_mod     = 1,
            branch_index   = 4,
        }
        data.level[28].special_hidden = true

        data.level[30].special = world.add_special{
            episode        = 5,
            depth          = 66,
            next           = 31,
            generator      = "dante_inferno",
            blueprint      = "level_dante_inferno",
            ilevel_mod     = 3,
            dlevel_mod     = 1,
            branch_index   = 5,
        }

        data.cot.level_index = world.add_special{
            episode        = 1,
            depth          = 1,
            blueprint      = "level_cot",
            lootbox_count  = 4,
            ilevel_mod     = 1,
            dlevel_mod     = 1,
            branch_index   = 1,
            returnable     = true,
            rewards        = {},
        }

        for idx,linfo in ipairs( data.level ) do
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
            nova.log(linfo.blueprint)
            if blueprints[linfo.blueprint].text then
                local name = blueprints[linfo.blueprint].text.name
                if type( name ) == "string" then
                    linfo.name = name
                end
            end
            linfo.name = linfo.name or ""
            nova.log("data.level"..tostring(idx)..(linfo.name))
            nova.log("data.level.next"..tostring(linfo.next))
        end
        world.data.special_levels = 19
        world.data.completionist_trial = true
        
		local guaranteed_uniques_cal = {2, 3, 4, 5, 6, 7}
		local guaranteed_uniques_eur = {10, 11, 12, 13, 14, 15}
		local guaranteed_uniques_io = {18, 19, 20, 21, 22, 23}
		
		world.data.cal_guaranteed_unique = table.remove( guaranteed_uniques_cal, math.random( #guaranteed_uniques_cal ) )
		world.data.eur_guaranteed_unique = table.remove( guaranteed_uniques_eur, math.random( #guaranteed_uniques_eur ) )
		world.data.io_guaranteed_unique = table.remove( guaranteed_uniques_io, math.random( #guaranteed_uniques_io ) )
		
		nova.log("Callisto unique on branch from "..world.data.cal_guaranteed_unique)
		nova.log("Europa unique on branch from "..world.data.eur_guaranteed_unique)
		nova.log("Io unique on branch from "..world.data.io_guaranteed_unique)
				
        world.data.unique.guaranteed = 0        
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
        nova.log("Generating quests")
        for _,b in ipairs( world.data.branch ) do
            nova.log("Generating quests for "..tostring(b.name).." #b.index "..tostring(#b.index))
            if b.quest and b.quest.list and not b.quest.no_info then
                local ilist = core.lists.quest_info[b.quest.list]
                local slist = core.lists.quest_short[b.quest.list]
                if ilist then
                    local target
                    local source
                    if #b.index <= 4 then
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
                        if epoint then
                            local pos = 1 + math.random( epoint - 1 )
                            source = pbranch.index[ pos ]
                        end
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
                    if source then
                        local idx = world:add_quest( player, world:create_entity( sid, target ) )
                        table.insert( world.data.level[source].quest, idx )
                    end 
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
        if entity.data and entity.data.ai and entity.attributes and
                ( not entity.data.is_player ) and entity.attributes.health and 
                ( not entity.data.boss ) and string.sub( world:get_id( entity ), 1, 7 ) ~= "exalted" then
            local linfo = world.data.level[ world.data.current ]
            if linfo then
                local dlevel = linfo.dlevel or 1
                local ep     = linfo.episode or 1               
                if ep > 3 and math.random( 100 ) < ( 20 + dlevel * 5 ) then
                    local count = ep - 3
                    local exalted_traits = {
                        { "exalted_kw_unstable", },
                        { "exalted_kw_hunter", min = 8, },
                        { "exalted_kw_tough", tag = "health" },
                        { "exalted_kw_resilient", min = 15, tag = "health" },
                        { "exalted_kw_accurate", },
                        { "exalted_kw_fast", min = 12, },
                        { "exalted_kw_lethal", tag = "damage" },
                        { "exalted_kw_deadly", min = 18, tag = "damage" }, 
                        { "exalted_kw_regenerate", tag = "health", min = 18, },
                    }
                    if entity.data.nightmare and entity.data.nightmare.id then
                        local nid = entity.data.nightmare.id
                        if blueprints[nid] and blueprints[nid].data and blueprints[nid].data.exalted_traits then
                            exalted_traits = blueprints[nid].data.exalted_traits
                        end
                    end

                    make_exalted( entity, dlevel, exalted_traits, { count = count, } )
                end
            end
        end
    end,
}