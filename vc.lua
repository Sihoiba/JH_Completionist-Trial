nova.require "data/lua/jh/data/generator"
nova.require "data/lua/jh/data/levels/callisto/valhalla/valhalla_command"

register_blueprint "common_shutdown_runtime_completionist"
{
    flags = { EF_NOPICKUP },
    attributes = {
        valhalla_tier    = 0,
        mimir_tier = 0,
    },
    callbacks = {
        on_enter_level = [=[
            function ( self, entity, reenter )
                world:preload( "mimir_sentry_bot_completionist" )
                local current_id = world.data.current
                local current    = world.data.level[ current_id ]
                if current.episode > 1 then
                    world:mark_destroy( self )
                    return
                end
                local level = world:get_level()
                local shouldRun = (current_id < 9)
                nova.log("Mimir returning "..tostring(reenter).." "..tostring(shouldRun))
                if reenter and not shouldRun then
                    if world.data.level[ world.data.current ] and world.data.level[ world.data.current ].blueprint then
                        local blueprint = world.data.level[ world.data.current ].blueprint
                        if self.attributes.valhalla_tier > 0 then
                            shouldRun = shouldRun or (blueprint == "level_callisto_valhalla")
                            nova.log("Valhalla returning from Valhalla central"..tostring(shouldRun))
                        end

                        if self.attributes.mimir_tier > 0 then
                            shouldRun = shouldRun or (blueprint == "level_callisto_mimir")
                            nova.log("Valhalla returning from Mimir central"..tostring(shouldRun))
                        end
                    end
                end
                if shouldRun then
                    nova.log("common runtime disabling")
                    local level = world:get_level()
                    for e in level:entities() do
                        if e.minimap and e.flags and e.flags.data[ EF_TARGETABLE ] and e.data.is_mechanical then
                            local id = world:get_id( e )
                            if self.attributes.mimir_tier > 1 and id == "mimir_sentry_bot_completionist" then
                                nova.log("common convert mimir")
                                aitk.convert( e, entity, true )
                            end
                            if self.attributes.valhalla_tier == 3 and id == "boss_tank_mech" then
                                nova.log("common disable warden")
                                aitk.disable( e, entity )
                                world:lua_callback( e, "bulwark_close" )
                                level.ui_boss.boss = nil
                            elseif self.attributes.valhalla_tier > 1 and id ~= "boss_tank_mech"  then
                                nova.log("common convert")
                                aitk.convert( e, entity, not e:flag( EF_NOCORPSE ) )
                            elseif id ~= "mimir_sentry_bot_completionist" and id ~= "boss_tank_mech" then
                                nova.log("common disable")
                                aitk.disable( e, entity )
                            end
                        end
                    end
                end
            end
        ]=],
    },
}

register_blueprint "valhalla_terminal_boss_completionist"
{
    text = {
        entry = "Shutdown CalSec Warden",
    },
    data = {
        terminal = {
            currency = "valhalla_keycard",
            priority = 0,
        },
    },
    attributes = {
        valhalla_keycard = 1,
    },
    callbacks = {
        on_activate = [=[
            function( self, who, level )
                if world:remove_items( who, "valhalla_keycard", 1 ) then
                    world:play_sound( "ui_terminal_accept", self )

                    local runtime = who:child( "common_shutdown_runtime_completionist" )
                    runtime.attributes.valhalla_tier = 3
                    world:add_experience( who, 200 )

                    local parent = self:parent()
                    world:destroy( self )
                    ui:activate_terminal( who, parent )
                    return 100
                else
                    return 0
                end
            end
        ]=]
    },
}

register_blueprint "valhalla_terminal_hack_completionist"
{
    text = {
        entry = "Hack CalSec",
    },
    data = {
        terminal = {
            currency = "valhalla_keycard",
            priority = 0,
        },
    },
    attributes = {
        valhalla_keycard = 1,
    },
    callbacks = {
        on_activate = [=[
            function( self, who, level )
                if world:remove_items( who, "valhalla_keycard", 1 ) then
                    world:play_sound( "ui_terminal_accept", self )
                    local runtime = who:child( "common_shutdown_runtime_completionist" )
                    runtime.attributes.valhalla_tier = 2
                    local ids = { security_bot_1 = true, adv_security_bot = true, }
                    for e in level:entities() do
                        if e.data and e.data.ai and e.data.ai.group ~= "player" then
                            if ids[ world:get_id( e ) ] then
                                if e:child("disabled") then
                                    aitk.convert( e, who, true )
                                end
                            end
                        end
                    end
                    local parent = self:parent()
                    world:destroy( self )
                    parent:attach( "valhalla_terminal_boss_completionist" )
                    ui:activate_terminal( who, parent )
                    return 100
                else
                    return 0
                end
            end
        ]=]
    },
}


register_blueprint "valhalla_terminal_shutdown_completionist"
{
    text = {
        entry = "Shutdown CalSec",
    },
    data = {
        terminal = {
            priority    = 0,
        },
    },
    attributes = {
        tool_cost   = 0,
        hacking_mod = 1,
    },
    callbacks = {
        on_activate = [=[
            function( self, who, level )
                local common_runtime = who:child( "common_shutdown_runtime_completionist" )
                if not common_runtime then
                    local runtime = who:attach( "common_shutdown_runtime_completionist" )
                    runtime.attributes.valhalla_tier = 1
                else
                    common_runtime.attributes.valhalla_tier = 1
                end
                local ids = { security_bot_1 = true, adv_security_bot = true, }
                for e in level:entities() do
                    if e.minimap and e.flags and ( e.flags.data[ EF_TARGETABLE ] or e.flags.data[ EF_ACTION ] ) then
                        if e.data and e.data.ai and e.data.ai.group ~= "player" then
                            if ids[ world:get_id( e ) ] then
                                aitk.disable( e, who )
                            end
                        end
                    end
                end
                local parent = self:parent()
                world:destroy( self )
                parent:attach( "valhalla_terminal_hack_completionist" )
                ui:activate_terminal( who, parent )
                return 100
            end
        ]=]
    },
}


valhalla_command_completionist = {}

function valhalla_command_completionist.generate(self, params )
    self:resize( ivec2( 54, 23 ) )
    self:set_styles{ "ts01_D", "ts02_A" }
    generator.fill( self, "wall" )
    local larea = self:get_area():shrinked( 1 )
    self:set_area_style( larea.a, larea.b, 1 )
    generator.archibald_area( self, larea, valhalla_command.tileset, { } )

    local rewards = {
        { "exo_dpistol", "exo_jpistol", "exo_cpistol", "adv_bpistol", "adv_rpistol", "adv_pistol", tier = math.random_pick{ 2,2,2,3 } },
        { "exo_gshotgun", "exo_jshotgun", "adv_ashotgun", "adv_shotgun", tier = math.random_pick{ 2,2,2,3 } },
        "lootbox_medical",
        { "adv_visor", "adv_helmet_blue", tier = math.random_pick{ 2,2,2,3 } },
    }
    rewards[3] = generator.episode_unique( self, "uni_launcher_firestorm" ) or rewards[3]

    local mug = generator.most_used_group()
    local greward = {
        melee      = { "adv_machete", tier = 2, },
        explosives = { "adv_rocket_launcher", tier = 2, },
        pistols    = { "adv_pistol", "adv_bpistol", "adv_rpistol", tier = 2, },
        smgs       = { "adv_smg", tier = 2, },
        shotguns   = { "adv_shotgun", tier = 2, },
        auto       = { "adv_auto_rifle", tier = 2, },
        semi       = { "adv_hunter_rifle", tier = 2, },
        rotary     = { "adv_auto_rifle", tier = 2, },
    }

    generator.drop_marker_rewards( self, "mark_special", larea, rewards )
    generator.handle_doors( self, self:get_area(), "marker", "valhalla_red_locked", { block = true } )
    generator.handle_doors( self, self:get_area(), "marker2", "valhalla_valsec_locked", { block = true, extra = "valhalla_valsec_info_1" } )
    generator.handle_doors( self, self:get_area(), "marker3", "valhalla_valsec_locked", { block = true, extra = "valhalla_valsec_info_2" } )
    generator.handle_doors( self, self:get_area(), "marker4", "valhalla_valsec_locked", { block = true, extra = "valhalla_valsec_info_3" } )

    local mrewards = {
        mark_decoration_1 = { "adv_armor_blue", tier = math.random_pick{ 2,2,2,3 } },
        mark_decoration_2 = greward[mug],
        mark_decoration_3 = { "kit_phase", "enviropack", "stimpack_small" },
        mark_decoration_4 = { "adv_amp_melee", "adv_amp_pistol", "adv_amp_shotgun", "adv_amp_auto", tier = math.random_pick{ 2,2,2,3 } },
        mark_decoration_5 = { "medkit_large",  },
    }

    generator.drop_marker_rewards( self, mrewards, larea )
    generator.clear_dual_dead_ends( self )
    local decorations = {
        mark_lootbox_ammo = { "floor", "plants_pot_01", placement = "env", },
    }
    generator.add_marked_entities( self, decorations )

    do
        local c = self:find_coord( "mark_turret" )
        self:set_cell( c, "floor" )
        local facing = generator.floor_facing( self, c, self:get_nid( "floor" ) )
        self:place_entity( "terminal_base", c, facing )
        local t = self:place_entity( "terminal", c, facing )
        t:attach( "valhalla_terminal_shutdown_completionist" )
        t:attach( "valhalla_terminal_cardhack" )
    end

    return { area = larea, no_elevator_check = true, }
end

register_blueprint "level_callisto_command_completionist"
{
    blueprint   = "level_base",
    text        = {
        name        = "Valhalla Command",
    },
    environment = {
        music        = "music_callisto_07",
    },
    level_info = {
        returnable = true,
    },
    callbacks = {
        on_create = [[
            function ( self )
                self.environment.lut = math.random_pick( luts.bluegray )
                generator.run( self, nil, valhalla_command_completionist.generate, valhalla_command.spawn )
            end
            ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
                local vo = "vo_callisto_command"
                if DIFFICULTY > 1 and math.random(2) == 1 then
                    vo = "vo_callisto_command_cool"
                end
                world:play_voice( vo )
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
                generator.apply_manufacturer( entity, "man_vs" )
            end
        ]],
    }
}
