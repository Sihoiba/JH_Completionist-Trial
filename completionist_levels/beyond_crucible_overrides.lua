nova.require "data/lua/jh/data/generator"

beyond_crucible_completionist = {}
beyond_crucible_completionist.tileset = {
    translation = {
        ["#"] = "wall",
        ["G"] = "gap",
        ["g"] =  { "gap", "ceiling_light_high_01_B", placement = "ceiling", },
        ["."] = "floor",
        ["E"] = "mark_elevator",
        [","] = { "floor", "ceiling_light_high_01_B", placement = "ceiling", },
        ["B"] = { "floor", "swordmaster", "ceiling_light_high_01_B", placement = "ceiling", },
        ["P"] = { "portal_off", "portal_01_off" },
        ["k"] = { "floor", "knife" },
        ["c"] = { "floor", "crowbar" },
    },
    size = coord.new(21,11),
    layout = {
        [[
        S
        X
        X
        X
        T
        ]]
    },
    ["T"] =
    {
{
    noflip = true,
    map =
[[
GGGGGGGGG..GGGGGGGGGG
GGGGGGGG..,..GGGGGGGG
GGGGGG.........GGGGGG
GGGGG...........GGGGG
GGGGG...#...#...GGGGG
GGGGG............GGGG
GGGGGG....B......GGGG
GGGGG..#.....#..GGGGG
GGGGG...........GGGGG
GGGGGG.G..#...GGGGGGG
GGGGGGGGG....GGGGGGGG
]],
},
    },
    ["X"] =
    {
{
    noflip = true,
map =
[[
GGGGGGGGGG.GGGGGGGGGG
GGGGGGGGGG.GGGGGGGGGG
GGGGGGGGG..GGGGGGGGGG
GGGGG,......GGGGGGGGG
GGGGGGG..GG.GGGGGGGGG
GGGGGGGG....GGGGGGGGG
GGGGGGG...gGGGGGGGGGG
GGGGGGG..GGGGGGGGGGGG
GGGGGGGG..GGGGGGGGGGG
GGGGGGGGG....GGGGGGGG
GGGGGGGGG..GGGGGGGGGG
]],
},
{
    noflip = true,
map =
[[
GGGGGGGGGG.GGGGGGGGGG
GGGGGGGGGG..GGGGGGGGG
GGGGGGGGG...GGGGGGGGG
GGGGGGGG...,GGGGGGGGG
GGGGGGGGG.GGGGGGGGGGG
GGGGGGGGG..GGGGGGGGGG
GGGGGGGGGG..GGGGGGGGG
GGGGGGGgGGG..GGGGGGGG
GGGGGGGGGGGG.GGGGGGGG
GGGGGGGGGG...GGGGGGGG
GGGGGGGGGG.GGGGGGGGGG
]],
},
{
    noflip = true,
map =
[[
GGGGGGGGGG.GGGGGGGGGG
GGGGGGGGGG..GGGGGGGGG
GGGGGGGGGGG...GGGGGGG
GGGGGGGGGGGG,GGGGGGGG
GGGGGGGGGGGG..GGGGGGG
GGGGGGGGGGG..GGGGGGGG
GGGGGGGGGG..GGGGGGGGG
GGGGGGGgGGG..GGGGGGGG
GGGGGGGGGGG..GGGGGGGG
GGGGGGGGGG....GGGGGGG
GGGGGGGGGG.GGGGGGGGGG
]],
},
{
    noflip = true,
map =
[[
GGGGGGGGG..GGGGGGGGGG
GGGGGGGGGG..GGGGGGGGG
GGGGGGGGGGG.GGGGGGGGG
GGGGGGGGGGG.GGGGGGGGG
GGGGGGG..G....GGGGGGG
GGGGGGGG....GGGGGGGGG
GGGGGGG..GgGGGGGGGGGG
GGGGGGGG..GGGGGGGGGGG
GGGGGGGGG.GGGGGGGGGGG
GGGGGGGGG..GGGGGGGGGG
GGGGGGGGGG.GGGGGGGGGG
]],
},
    },
    ["S"] =
    {
{
    noflip = true,
map =
[[
GGGGGgGGG...GGGGgGGGG
GGGG.GGG..#...G..GGGG
GGG.............GGGGG
GGGGGG.#.....#..GGGGG
GGGGGG...cPk....GGGGG
GGGGG...........GGGGG
GGGGGG..#...#..GGGGGG
GGGGGGG...,...GGGGGGG
GGGGGGGG...G.GGGGGGGG
GGGGGGGGG..GGGGGGGGGG
GGGGGGGGGG..GGGGGGGGG
]],
},
}
}

register_blueprint "level_beyond_crucible_completionist"
{
    blueprint   = "level_base",
    text = {
        name        = "The Shattered Abyss",
        weapon_fail = "The weapon doesn't seem to work!",
        return_open = "Return portal opens...",
    },
    level_vo = {
        silly   = 0.0,
        serious = 1.0,
    },
    level_info  = {
        clear_vo = "",
    },
    attributes  = {
        exit_active = 0,
    },
    ui_boss     = {},
    environment = {
        lut          = "lut_07_yellowish",
        music        = "music_beyond_04",
        hdr_exposure = 2.4,
    },

    callbacks = {
        on_create = [[
            function ( self )
                self:resize( ivec2( 25, 61 ) )
                self:set_styles{ "ts09_D", "ts09_D" }

                local generate = function( self, params )
                    generator.fill( self, "gap" )
                    local larea = self:get_area():shrinked(3)
                    generator.archibald_area( self, larea, beyond_crucible_completionist.tileset )
                    return { area = larea, no_elevator_check = true, }
                end

                local spawn = function( self )
                    local area_1 = area( coord( 5, 20 ), coord( 20, 30 ) )
                    local area_2 = area( coord( 5, 32 ), coord( 20, 40 ) )
                    local sa = self:get_area()
                    local count = 5 + DIFFICULTY
                    for k = 1,count do
                        local d = self:add_entity( "reaver", area_1:random_coord() )
                        d.data.ai.state = "wait"
                    end
                    for k = 1,count do
                        local d = self:add_entity( "archreaver", area_2:random_coord() )
                        d.data.ai.state = "wait"
                    end
                end

                generator.run( self, nil, generate, spawn )
            end
            ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
                world:play_voice( "vo_beyond_crucible" )
                world:special_visited( player, self )
                player:attach( "level_beyond_crucible_runtime" )
            end
        ]],
        on_pre_command = [[
            function ( self, entity, command, w, coord )
                if command == COMMAND_USE then
                    if w and w.weapon and w.weapon.type ~= world:hash("melee") then
                        ui:set_hint( "{R"..self.text.weapon_fail.."}", 2001, 0 )
                        return -1
                    end
                end
                return 0
            end
            ]],
        on_move = [[
            function ( self, who, position )
                if who == world:get_player() then
                    if self.attributes.exit_active == 0 then
                        self.attributes.exit_active = 1
                        local e = self:place_entity( "portal_01", self:find_coord( "portal_off" ) )
                        ui:set_hint( self.text.return_open, 2001, 0 )
                        world:play_sound( "dash_02", e )
                    end
                end
            end
        ]],
        on_cleared = [[
            function ( self )
                world:special_cleared( world:get_player(), self )
            end
        ]],
    }
}
