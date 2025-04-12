nova.require "data/lua/jh/data/generator"
nova.require "data/lua/jh/data/levels/europa/europa_refueling"
nova.require "completionist_levels/europa/europa_items_overrides"

register_blueprint "level_europa_refueling_completionist"
{
    blueprint   = "level_base",
    text        = {
        name        = "Refueling Base",
    },
    attributes = {
        returnable = true,
        valve_count = 0,
    },
    level_info  = {
        light_range = 5,
    },
    environment = {
        hdr_exposure = 1.8,
        volumetric   = -0.70,
        music        = "music_europa_03",
    },
    callbacks = {
        on_create = [[
            function ( self )
                self.environment.lut = math.random_pick( luts.bluegray )
                local generate = function( self, params )
                    self:resize( ivec2( 51, 50 ) )
                    self:set_styles{ "ts03_A:pillar", "ts04_A", "ts06_A", "ts05_C", "ts05_C:gap_column" }
                    generator.color_set = {
                        "ceiling_light_04",
                        "ceiling_light_04",
                    }

                    local result = generator.layout_room_fill_level( self, europa_refueling_rooms, params, europa_refueling_layouts )
                    local larea = result.area
                    local tile  = map_tile.new( europa_refueling_room.map, translation.pure, self )
                    tile:place( self, ivec2( 22, 17 ), generator.placer, self )

                    local rewards = {
                        { "adv_armor_red", "adv_armor_blue", "adv_assault_rifle", "adv_hunter_rifle", "adv_amp_auto", "adv_amp_pistol", "adv_amp_shotgun", tier = math.random_pick{ 3,3,4 }, },
                        { "adv_headset", "adv_helmet_red", "adv_cvisor", tier = math.random_pick{ 3,3,4 }, },
                        { "terminal_ammo", },
                        { "powerup_backpack_completionist", },
                        { "adv_amp_general", tier = math.random_pick{ 3,3,4 } },
                    }
                    rewards[1] = generator.episode_unique( self, "uni_launcher_calamity" ) or rewards[1]

                    local mug = generator.most_used_group()
                    local greward = {
                        melee      = { "adv_amp_melee",   tier = 4 },
                        explosives = { "adv_amp_general", tier = 4 },
                        pistols    = { "adv_amp_pistol",  tier = 4 },
                        smgs       = { "adv_amp_pistol",  tier = 4 },
                        shotguns   = { "adv_amp_shotgun", tier = 4 },
                        auto       = { "adv_amp_auto",    tier = 4 },
                        semi       = { "adv_amp_auto",    tier = 4 },
                        rotary     = { "adv_amp_auto",    tier = 4 },
                    }

                    generator.drop_marker_rewards( self, "mark_special", larea, rewards )
                    generator.drop_marker_rewards( self, "mark_turret", larea, { greward[ mug ] } )
                    generator.drop_marker_rewards( self, "marker2",     larea, { { "armor_env" } } )
                    generator.drop_marker_rewards( self, "marker4",     larea, { { "medkit_large" } } )
                    generator.handle_doors( self, self:get_area(), "marker3", "locked", { block = true } )
                    local etables = {
                        [0] = weight_list { { 1, "ice_fiend" }, { 1, "fiend" }, { 1, "ravager" }, { 1, "cryoreaver" }, { 1, "archreaver" }, },
                        [1] = weight_list { { 1, "ice_fiend" },                 { 1, "ravager" }, { 1, "cryoreaver" }, { 1, "archreaver" }, },
                        [2] = weight_list {                                     { 1, "ravager" }, { 1, "cryoreaver" }, { 1, "archreaver" }, },
                    }

                    local mroom = math.random(4)
                    for _,r in ipairs( result.rooms_list ) do
                        local l = 0
                        if mroom == i then l = 1 end
                        local count = 4 + DIFFICULTY
                        local ra = r:shrinked(2)
                        for k = 1,count do
                            self:add_entity( etables[math.min(DIFFICULTY + l,2)](), ra:random_coord() )
                        end
                    end
                    result.no_elevator_check = true
                    return result
                end
                local spawn    = function( self )
                end

                generator.run( self, nil, generate, spawn )
            end
            ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
                world:play_voice( "vo_europa_refueling" )
                world:special_visited( player, self )
            end
        ]],
        on_cleared = [[
            function ( self )
                world:special_cleared( world:get_player(), self )
            end
        ]],
    },
}
