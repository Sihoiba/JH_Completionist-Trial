-- DANTE VESTIBULE

dante_intro_completionist = {}

function dante_intro_completionist.generate( self, params )
    self:resize( ivec2( 59, 31 ) )
    self:set_styles{ "tsX_A:rand","tsX_A:deco"  }
    generator.color_set = {
        "ceiling_light_06",
        "ceiling_light_05",
    }
    generator.fill( self, "gap" )
    local larea  = self:get_area():shrinked(1)
    local result = generator.archibald_area( self, larea, dante_intro.tileset, {} )
    result.area  = larea
    generator.map_symmetry_y( self, 15 )
    local entry  = self:find_coord( "mark_elevator_entry" )
    if entry then
        self:set_cell( entry, "portal_off" )
        self:add_entity( "portal_01_off", entry )
        self:place_entity( "ceiling_light_05", entry )
    end
    local exit   = self:find_coord( "mark_elevator_exit" )
    if exit then
        self:set_cell( exit, "elevator" )
        local facing = generator.floor_facing( self, exit, { [self:get_nid( "floor" )] = true, [self:get_nid( "floor_elevator" )] = true, } )
        entity = self:place_entity( "elevator_01", exit, facing )
    end

    local coords = generator.find_coords( self, "mark_elevator" )
    if DIFFICULTY > 0 then
        local ecoord = table.remove( coords, math.random( #coords ) )
        local facing = generator.floor_facing( self, ecoord, { [self:get_nid( "floor" )] = true, [self:get_nid( "floor_elevator" )] = true } )
        self:place_entity( "elevator_01_branch", ecoord, facing )
        self:set_cell( ecoord, "elevator_branch" )
    end

    for _, c in ipairs( coords ) do
        self:set_cell( c, "wall" )
    end


    generator.checker_style( self, "gap" )
    generator.drop_marker_rewards( self, "marker", larea, {"terminal_ammo", "terminal_ammo" } )

    local cri_area = area( coord( 30, 1 ), coord( 45, 30 ) )
    local dan_area = area( coord( 1, 1 ), coord( 20, 30 ) )


    generator.generate_litter( self, cri_area, {
        litter = { "crate_01", "crate_02", "crate_03", "crate_04", "barrel_fuel", { "forklift_01", 0.1 } },
        chance = 25,
        alt    = "altfloor",
    })

    generator.generate_litter( self, dan_area, {
        litter = { "crate_dante", "crate_dante", "barrel_dante",
        { "crate_dante_group", 0.2 } },
        chance = 20,
        alt    = "altfloor",
    })
    for c in self:coords( "marker3" ) do
        self:set_cell( c, "floor" )
        self:place_entity( "dante_obelisk_02", c, generator.env_facing( c ) )
    end

    result.no_elevator_check = true
    return result
end

function dante_intro_completionist.spawn( self )
    local cri_area = area( coord( 20, 1 ), coord( 40, 30 ) )
    local dan_area = area( coord( 1, 1 ),  coord( 30, 30 ) )

    local value = generator.std_exp_value()
    generator.spawn_enemies( self, value * 0.4, {
        list  = core.lists.being.cri,
        mod   = { civilian = 0.2, },
        area  = cri_area,
        safe  = "portal_off",
    })
    generator.spawn_enemies( self, value * 0.7, {
        list  = core.lists.being.dante,
        area  = dan_area,
        safe  = "portal_off",
    })
end

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
                generator.run( self, nil, dante_intro_completionist.generate, dante_intro_completionist.spawn )
            end
            ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
                ui:set_achievement( "acv_level_beyond_01" )
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