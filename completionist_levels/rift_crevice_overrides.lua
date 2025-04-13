nova.require "data/lua/jh/data/generator"
nova.require "completionist_levels/rift_common_overrides"
nova.require "data/lua/jh/data/levels/callisto/rift/rift_crevice"


rift_crevice_completionist = {}
rift_crevice_completionist.tileset = {
    size = coord.new( 15, 15 ),
    no_flip = true,

    layout = [[
    ABC
    DEF
    GHI
    ]],

    ['A'] = {
        {
            no_flip = true,
            map = [[
            ###############
            #######..###SSS
            ##.,#,..##..S__
            ###...g.##.,+__
            ####.gg.,..#S__
            ##.,..ggg.,.SSS
            #####,.gg..####
            ####,..ggg..###
            ###.....ggg,.##
            #####..ggggg..#
            ####,.ggggggg..
            ##...ggg,.gg...
            ###..g.......gg
            ####...##,.gggg
            ##########..ggg
            ]],
        },
        {
            no_flip = true,
            map = [[
            ###############
            #####...####SSS
            ##...,g.###.S__
            ####..g..#.,+__
            ####.gg.,...S__
            ##.,..gggg,.SSS
            #..gggggg..####
            ##..,.gggg..#.#
            #####...ggg,.,#
            #####.,ggggg..#
            ####,...gg.....
            ###..##.,..ggg.
            #####,..#.ggggg
            ####..###,.gggg
            ##########..ggg
            ]],
        },
        {
            no_flip = true,
            map = [[
            ###############
            ##...,.#####SSS
            ###.gg..##..S__
            ##...gg....,+__
            ##.g.ggg,...S__
            ##.,gggg.g,.SSS
            #...gggggg..###
            #.g.,.ggggg.###
            #,gg....ggg,.##
            #..ggg,ggggg..#
            ##..gg..gggg...
            ##.,.gg.,....g.
            #..#.,gg..ggggg
            #####....,.gggg
            ##########..ggg
            ]],
        },
    },

    ['B'] = {
        {
            no_flip = true,
            map = [[
            ###############
            SSS############
            __S############
            _MS############
            __S##########SS
            SSS##########S_
            #############S_
            #############S_
            #############S_
            ##,##########S_
            .#..#########S_
            .,.#.####SSSSS_
            gg..,.##.S_____
            gg,...,._L___^_
            ggg....._L_____
            ]],
        },
        {
            no_flip = true,
            map = [[
            ###############
            SSS############
            __S############
            _MS############
            __S###.######SS
            SSS#..,######S_
            ####.g..#####S_
            ##..,g.######S_
            #..gg..######S_
            ##,ggg...####S_
            .#..ggg,#####S_
            .,...g..#SSSSS_
            gg..,..#.S_____
            ggggg.,._L___^_
            ggg....._L_____
            ]],
        },
        {
            no_flip = true,
            map = [[
            ###############
            SSS############
            __S############
            _MS####.#######
            __S##...#####SS
            SSS#.,#...###S_
            ####.####.###S_
            ###..#.#,.###S_
            ####.,...####S_
            ##,#..#######S_
            .#.....######S_
            .,...####SSSSS_
            gg..,.##.S_____
            gg,g..,._L___^_
            ggg....._L_____
            ]],
        },
    },


    ['C'] = {
        {
            no_flip = true,
            map = [[
            ###############
            #####SSSSSS####
            ####SSz___SSS##
            ###SS___m__SS##
            SSSS_v____Z_SS#
            __S___z__z___S#
            __L_____m__m_S#
            __L__________S#
            _^S___z__z__zS#
            __SS_v____v_SS#
            __SSS______SS##
            __SSSS____SS###
            __SSSSSLLSS####
            _^____^___S####
            __________S####
            ]],
        },
    },

    ['D'] = {
        {
            no_flip = true,
            map = [[
            ##########..ggg
            ###.#.#####..gg
            ##...,.#####.,g
            #..SSS...###...
            #..SES.g,.####.
            ##..e,.gg.,.###
            ###..gggg..####
            ####,..ggg..###
            #####.ggggg..##
            ####..,gggg.###
            #####.ggggg.,##
            #####.g.ggg..##
            ####...,.ggg..#
            #####.#..gggg.#
            #######..gggg..
            ]],
        },
        {
            no_flip = true,
            map = [[
            ##########..ggg
            ###.#######..gg
            ##...,####...,g
            #..g.SSS.###...
            #.g..SES,..###.
            #,gg.,e..g,.###
            #..ggg..gg.####
            ##..,gggg...###
            ##.g..ggg.g..##
            ##.gg.,.ggg.###
            ##.,ggg..gg.,##
            ###..gg.ggg..##
            ##....g,.ggg..#
            ###.#.....ggg.#
            #######..gggg..
            ]],
        },
        {
            no_flip = true,
            map = [[
            ##########..ggg
            ###SSS#####..gg
            ##.SES.#####.,g
            ##..e.,..##....
            ##...gg.#.###..
            #.,gggg...,####
            ##..ggggg....##
            ###.,..ggggg..#
            ##..#.gggg..,.#
            #..##.,gggg..##
            ##..##..gg..###
            ###,.#.ggg,..##
            ##.....,gggg.##
            ###.##...ggg..#
            #######..gggg..
            ]],
        },

    },

    ['E'] = {
        {
            no_flip = true,
            map = [[
            ggg....._L_____
            gggg..,..S___^_
            gggg.,...SSSS__
            .,ggggg....,S__
            ....gggg,...S__
            ##.,.ggg..,.SSL
            ###...ggg....._
            ##..,ggggg...,.
            #.,#..gggg,....
            ###...g.gggg...
            #####.,...ggg..
            ###...##..g...g
            ####.####....gg
            ########.......
            .######SSS+SSS.
            ]],
        },
        {
            no_flip = true,
            map = [[
            ggg....._L_____
            gggg.,g..S___^_
            gggg.gg..SSSS__
            .,...gg....,S__
            ...gggggg...S__
            ##.,gggggg,.SSL
            ###..gggg....._
            ##..gg.,gg.g.,.
            #.,ggg..gg,gg..
            #...ggg.gggg...
            ###..g,...ggg,.
            ###.,gg...g.ggg
            ####...g,....gg
            ######.........
            .######SSS+SSS.
            ]],
        },
        {
            no_flip = true,
            map = [[
            ggg....._L_____
            gggg..#,.S___^_
            gggg.,...SSSS__
            .,ggggg....,S__
            ....gggg,...S__
            #..ggggg..,.SSL
            ##,.ggg...g..._
            #..ggg...ggg.,.
            #...ggg...,gg..
            ##,gggg.g....g.
            ##.g.gggg.gg...
            #....ggggggg.gg
            ###.,.gggg...gg
            ####...........
            .######SSS+SSS.
            ]],
        },
    },

    ['F'] = {
        {
            no_flip = true,
            map = [[
            __________S####
            _^_SSSSSSSS####
            ___S###########
            ___S###########
            ___S###########
            LLSS###########
            __.############
            ..#############
            .##############
            .,.############
            .....##########
            g,..###########
            ggg..####SSSSS#
            .g.,#####S_M_S#
            .gg..####S___S#
            ]],
        },
        {
            no_flip = true,
            map = [[
            __________S####
            _^_SSSSSSSS####
            ___S###########
            ___S###########
            ___S###########
            LLSS####.SS####
            __.##....SS.###
            ..####....,..##
            .####..SS..SS##
            .,.#..,SS..SS##
            ..........#####
            g,g..,#.#######
            ggg..####SSSSS#
            .g.,#####S_M_S#
            .gg..####S___S#
            ]],
        },
        {
            no_flip = true,
            map = [[
            __________S####
            _^_SSSSSSSS####
            ___S###########
            ___S###.#######
            ___S###...#.###
            LLSS##..g.,..##
            __.###.g...g.##
            ..##...gg.gg.##
            .##...gg..g..##
            .,...ggg,...###
            .....g...######
            g,gg....#######
            ggg...###SSSSS#
            .g.,#####S_M_S#
            .gg..####S___S#
            ]],
        },
    },

    ['G'] = {
        {
            no_flip = true,
            map = [[
            #######..gggg..
            ########,.gggg.
            #########..gggg
            #######.,.gg,gg
            ########.....gg
            #########.##,..
            #########,.##..
            #######...####.
            ######,....####
            #####......####
            ####SSS+SSS####
            ####S_____S####
            ####S^_K_^S####
            ####SSSSSSS####
            ###############
            ]],
        },
        {
            no_flip = true,
            map = [[
            #######..gggg..
            ######..,.gggg.
            ######..ggggggg
            ####...gg.gg,gg
            #..,.gggg....gg
            ##.ggg....##,..
            ##..gg..#,.##..
            ###.g..#..####.
            ###..,###...###
            ##,......,.####
            ####SSS+SSS####
            ####S_____S####
            ####S^_K_^S####
            ####SSSSSSS####
            ###############
            ]],
        },
        {
            no_flip = true,
            map = [[
            #######..gggg..
            ########,.gggg.
            #########...ggg
            #######.,...,gg
            #####,..#..gggg
            ###...##..gg,..
            ##..#####,.....
            ##...#####..##.
            ###,#####....##
            ###.........###
            ##..SSS+SSS.###
            ###.S_____S####
            ####S^_K_^S####
            ####SSSSSSS####
            ###############
            ]],
        },
    },

    ['H'] = {
        {
            no_flip = true,
            map = [[
            .######SSS+SSS.
            ...####S_____S.
            gg..###S_____S.
            ggg..#.S_____S.
            gggg...S_____S.
            .gg....SSS+SSS#
            ..g.gg,...,####
            ....gggg.######
            #..ggggg...####
            ##....gggg..###
            ####..ggg..####
            ###..,.ggg.,#.#
            ####.#...g....#
            ########....###
            ###############
            ]],
        },
        {
            no_flip = true,
            map = [[
            .######SSS+SSS.
            ...####S_____S.
            gg...##S_____S.
            gg..##.S_____S.
            ggg....S_____S.
            ....g..SSS+SSS#
            .,gggg,...,.###
            ....gggg.gg..##
            #..gggg,..gg,##
            ##..,.ggg..g..#
            #...ggggg..gg.#
            ###..g.ggg.,g.#
            ####.....g....#
            #####.##,...###
            ###############
            ]],
        },
        {
            no_flip = true,
            map = [[
            .######SSS+SSS.
            ...####S_____S.
            gg..,##S_____S.
            ggg..##S_____S.
            gggg..#S_____S.
            ..ggg..SSS+SSS#
            ..g.gg,...,####
            ..,.gggg..##..#
            #...g...,....##
            ##....gg.g..###
            ####...ggg.####
            ###..,..gg.,###
            ##...#.......##
            #..#####..#####
            ###############
            ]],
        },
    },

    ['I'] = {
        {
            no_flip = true,
            map = [[
            .gg..####S___S#
            .ggg...##S___S#
            ..gggg..#SS+SS#
            .gggg......,.##
            .,.gggg.,gg..##
            ##.,ggggg.,.###
            ###..gggg...###
            ##..gg.gggg..##
            #.,...,.gg,.###
            ###.....,gg,..#
            ###.#.,#,,g.###
            ##..#####..,.##
            ############.##
            ###############
            ###############
            ]],
        },
        {
            no_flip = true,
            map = [[
            .gg..####S___S#
            .ggg...##S___S#
            ..gggg...SS+SS#
            .ggggggg...,.##
            .,....ggggg..##
            ##.,g...gg,.###
            ###.ggg.....###
            ##..ggggggg..##
            ###,..gggg,.###
            ##.......gg,..#
            ##..##.#,.g.###
            #...#####..,.##
            ##..,.######.##
            ###...#########
            ###############
            ]],
        },
        {
            no_flip = true,
            map = [[
            .gg..####S___S#
            .ggg.,.##S___S#
            ..gggg..#SS+SS#
            .gggggg....,.##
            .,.ggg.....#.##
            #..gggggg.,.###
            ##...ggggg..###
            ##..gg...gg..##
            #.,ggg,#..gg.##
            #.ggg..##.gg..#
            #..gg.###,g..##
            ##.g..##..g..##
            ##...##..g.,..#
            ########...####
            ###############
            ]],
        },
    },

    translation = {
        ["#"] = "wall",
        ["S"] = { "wall", style = 1 },
        ["g"] = "gap",
        ["G"] = { "gap", light = 1, },
        ["&"] = "cargo",
        ["."] = "floor",
        ["_"] = { "floor", style = 1, },
        ["^"] = { "floor", style = 1, light = 1 },
        ["+"] = { "door_frame", style = 1},
        ["m"] = { "marker" },
        ["M"] = { "marker2", style = 1 },
        ["L"] = { "marker3", style = 1 },
        ["K"] = { "floor", "rift_switch_completionist", style = 1 },
        ["Z"] = { "floor_vent", style = 1, },
        ["z"] = { "mark_special", style = 1, },
        ["E"] = { "mark_elevator", },
        ["e"] = { "floor_elevator", },
        [","] = { "floor", light = 1, },
        ["'"] = { "floor", light = 2, },
        ["A"] = { "floor", "plants_pot_01", placement = "rwall", },
        ["D"] = { "floor", "tsa_desk_01", placement = "env", },
        ["V"] = { "floor", "vending_01", placement = "rwall", },
        ["T"] = { "floor", "terminal_base", "terminal",  style = 2,    placement = "floor", },
        ["1"] = { "floor", "chairs_quad" },
        ["v"] = { "floor", "large_top_vent", style = 1, },
    }

}

function rift_crevice_completionist.generate( self, params )
    self:resize( ivec2( 43, 43 ) )
    self:set_styles{ "ts09_B", "ts06_B:ext", }
    generator.fill( self, "gap" )
    local result = generator.archibald_area( self, self:get_area(), rift_crevice_completionist.tileset, { no_remove_doors = true, no_elevator_check = true, } )

    -- Spawn enemies
    local etables = {
        [0] = weight_list {
            { 3, "fire_fiend" },
            { 2, "fiend" },
            { 1, "ice_fiend" },
        },
        [1] = weight_list {
            { 3, "fire_fiend" },
            { 2, "fiend" },
            { 2, "ice_fiend" },
        },
        [2] = weight_list {
            { 3, "fire_fiend" },
            { 2, "ice_fiend" },
            { 1, "toxic_fiend" },
        },
        [3] = weight_list {
            { 2, "fire_fiend" },
            { 2, "ice_fiend" },
            { 1, "toxic_fiend" },
        },
        [4] = weight_list {
            { 2, "fire_fiend" },
            { 2, "ice_fiend" },
            { 2, "toxic_fiend" },
        },
    }

    local spawn_areas = {
        area( ivec2( 0, 0 ), ivec2( 13, 13 ) ),
        area( ivec2( 13, 0 ), ivec2( 27, 13 ) ),
        area( ivec2( 13, 13 ), ivec2( 27, 27 ) ),
        area( ivec2( 27, 13 ), ivec2( 42, 27 ) ),
        area( ivec2( 27, 27 ), ivec2( 42, 42 ) ),
    }

    local ecount = 0
    while ecount < 15 + DIFFICULTY * 2 do
        local random_area = spawn_areas[ math.random( 5 ) ]
        local p = random_area:random_coord()
        local fid = self:get_nid( "floor" )

        if self:get_cell_style( p ) == 0 and self:raw_get_cell( p ) == fid then
            self:add_entity( etables[ math.min( DIFFICULTY, 4 ) ](), p )
            ecount = ecount + 1
        end
    end

    -- Spawn guard enemy
    local gtable = {
        { "drone1", "sentry_bot_3", "drone1", },
        { "drone2", "sentry_bot_3", "drone2", },
        { "drone2", "security_bot_3", "drone2", },
        { "sentry_bot_2", "security_bot_3", "sentry_bot_2", },
        { "sentry_bot_3", "security_bot_3", "sentry_bot_3", },
    }

    local gcount = 1
    for c in self:coords( "marker" ) do
        self:set_cell( c, "floor" )
        self:set_cell_style( c, 1 )
        local e = self:add_entity( gtable[ math.min( DIFFICULTY + 1, 5 ) ][ gcount ], c )
        e.data.ai.state = "wait"
        gcount = gcount + 1
    end

    generator.handle_doors( self, self:get_area(), "marker3", "locked", { block = true } )

    --Close reward room doors:
    local rarea = area( ivec2( 21, 0 ), ivec2( 42, 21 ) )


    -- Add terminals opening reward room
    local rarea_a = {
        area( ivec2( 22, 0 ), ivec2( 28, 27 ) ),
        area( ivec2( 24, 16 ), ivec2( 42, 26 ) ),
    }

    local rarea_b = {
        area( ivec2( 29, 0 ), ivec2( 42, 14 ) ),
    }

    local term_a_area = area( ivec2( 14, 0 ), ivec2( 29, 15 ) )
    local term_b_area = area( ivec2( 29, 14 ), ivec2( 42, 29 ) )

    for c in self:coords( "marker2", term_a_area ) do
        self:set_cell( c, "floor" )
        local facing = generator.floor_facing( self, c, floor_id )
        self:place_entity( "terminal_base", c, facing )
        local e = self:place_entity( "callisto_crevice_terminal", c, facing )

        e:attach( "level_callisto_crevice_terminal_lock", { data = { areas = rarea_a, }, text = { entry = "Open Bunker Airlock" } } )
    end

    for c in self:coords( "marker2", term_b_area ) do
        self:set_cell( c, "floor" )
        local facing = generator.floor_facing( self, c, floor_id )
        self:place_entity( "terminal_base", c, facing )
        local e = self:place_entity( "callisto_crevice_terminal", c, facing )

        e:attach( "level_callisto_crevice_terminal_lock", { data = { areas = rarea_b, }, text = { entry = "Open Bunker Storage" } } )
    end

    local rewards = {
        { "adv_bpistol", "adv_ashotgun", tier = 2 },
        "technical_station",
        "medical_station",
        { "lootbox_armor", attach = { "kit_multitool", }, },
        { "lootbox_special", tier = 3, attach = generator.episode_unique( self ) },
        {},
    }

    local mug = generator.most_used_group()
    local greward = {
        melee      = { "adv_amp_melee", tier = 2, },
        explosives = { "adv_amp_general", tier = 2, },
        pistols    = { "adv_amp_pistol", tier = 2, },
        smgs       = { "adv_amp_pistol", tier = 2, },
        shotguns   = { "adv_amp_shotgun", tier = 2, },
        auto       = { "adv_amp_auto", tier = 2, },
        semi       = { "adv_amp_auto", tier = 2, },
        rotary     = { "adv_amp_auto", tier = 2, },
    }
    rewards[6] = greward[ mug ]

    generator.drop_marker_rewards( self, "mark_special", rarea, rewards )
    result.no_elevator_check = true
    return result
end

register_blueprint "level_callisto_crevice_completionist"
{
    blueprint   = "level_base",
    text = {
        name  = "The Rift",
    },
    attributes = {
        rift_master = 1,
        returnable  = true,
        stage       = 0,
    },
    environment = {
        music        = "music_beyond_01",
        lut          = "lut_06_blueish",
        hdr_exposure = 1.8,
    },

    callbacks = {
        on_create = [[
            function ( self )
                generator.run( self, nil, rift_crevice_completionist.generate )
            end
        ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
                world:play_voice( "vo_callisto_rift" )
                world:special_visited( player, self )
            end
            ]],
        on_cleared = [[
            function ( self )
                world:special_cleared( world:get_player(), self )
            end
        ]],
        on_create_entity = [[
            function ( level, entity )
                generator.apply_manufacturer( entity, "man_js" )
            end
        ]],
        on_switch = [[
            function ( level )
                local c = level:find_coord( "floor_vent" )
                world:destroy( level:get_entity( c,"grate" ) )
                level:place_entity( "rift_smoke", c )
            end
        ]],
    },
}
