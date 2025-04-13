nova.require "data/lua/jh/main"

-- BEYOND INTRO

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
                self:resize( ivec2( 38, 38 ) )
                self:set_styles{ "ts06_A", "ts09_A:runes", }
                local generate = function( self, params )
                    generator.color_set = {
                        "ceiling_light_06",
                        "ceiling_light_05",
                    }
                    generator.fill( self, "wall" )
                    local larea = self:get_area()
                    params.elevators = 0
                    local result = generator.archibald_area( self, self:get_area(), beyond_intro.tileset, params )
                    local fid = self:get_nid("floor")
                    local wid = self:get_nid("wall")
                    local did = self:get_nid("door_frame")
                    generator.fill_edges( self, "wall", self:get_area() )
                    for c in larea:shrinked(1):edges() do
                        if self:raw_get_cell( c ) == did then
                            self:set_cell( c, "wall" )
                        end
                    end

                    for c in larea:edges() do
                        if self:around( c, wid ) > 3 and self:cross_around( c, fid ) == 1 then
                            self:set_cell( c, "wall_vent" )
                        end
                    end
                    generator.generate_litter( self, larea, {
                        litter = { "crate_01", "crate_02", "crate_03", "crate_04", "barrel_fuel", "barrel_toxin", { "forklift_01", 0.2 } },
                        chance = 25,
                    })
                    result.no_elevator_check = true
                    return result
                end

                generator.run( self, nil, generate )
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

-- BEYOND PRECIPICE

register_blueprint "level_beyond_percipice_completionist"
{
    blueprint  = "level_base",
    text       = {
        name   = "Precipice of Defeat",
    },
    attributes  = {
        portal      = 0,
        summoner_dead = false,
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

                self:resize( ivec2( 70, 30 ) )
                self:set_styles{ "ts09_A:runes" }

                local generate = function( self )
                    generator.fill( self, "gap" )
                    local larea    = self:get_area():shrinked(7)
                    local tileinfo = beyond_percipice_completionist.tile
                    tileinfo.translation["S"][3] = "summoner_c"
                    if world.data.exalted_boss or DIFFICULTY > 3 then
                        tileinfo.translation["S"][3] = "exalted_summoner_c"
                    end
                    local tile  = map_tile.new( tileinfo.map, tileinfo.translation, self )
                    tile:flip_xy()
                    tile:place( self, larea.a, generator.placer, self )
                    for c in self:coords( "marker3" ) do
                        self:set_cell( c, "floor" )
                        table.insert( world.data.dante_altar.marks, c:clone() )
                    end
                    return { area = larea, no_elevator_check = true }
                end

                local spawn = function( self )
                    generator.spawn_enemies( self, 10000, {
                        list       = core.lists.being.beyond,
                        mod        = { bot = 0, drone = 0, former = 0 },
                        level      = 28,
                        safe       = "portal_off",
                        safe_range = 7,
                    })
                end

                generator.run( self, nil, generate, spawn )
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
                -- This is needed because the summoner adds 1 to the world enemy count every time it teleports on the health trigger.
                if self.level_info.enemies > 2 then return 0 end
                if not self.attributes.summoner_dead then return 0 end
                return 1
            end
        ]],
        on_kill = [[
            function ( self, killed, killer, all )
                if self.attributes.portal == 0 and killed.data.boss then
                    local e = self:place_entity( "portal_01", self:find_coord( "portal_off" ) )
                    ui:spawn_fx( nil, "fx_summon_exalted", nil, world:get_position( e ) )
                    self.attributes.summoner_dead = true
                end
                if self.level_info.enemies == 2 and self.attributes.summoner_dead then
                    self.level_info.cleared = true
                    nova.log("Beyond precipice cleared")
                end
            end
        ]],
    }
}

beyond_percipice_completionist = {}
beyond_percipice_completionist.tile = {
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