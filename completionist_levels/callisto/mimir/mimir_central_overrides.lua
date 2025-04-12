nova.require "data/lua/jh/data/generator"
nova.require "completionist_levels/callisto/mimir/mimir_common_overrides"
nova.require "completionist_levels/callisto/valhalla/valhalla_command_overrides"
nova.require "data/lua/jh/data/levels/callisto/mimir/mimir_common"
nova.require "data/lua/jh/data/levels/callisto/mimir/mimir_central"
nova.require "data/lua/jh/data/levels/callisto/mimir/mimir_tilesets"	

register_blueprint "mimir_shutdown_runtime_completionist"
{
    flags = { EF_NOPICKUP },
    attributes = {
        counter = 0,
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
            end
        ]=],
        on_timer = [[
            function ( self, first )
                if first or world:current_transfer() > 0 then return 500 end
                local counter = self.attributes.counter
                if counter > 0 then
                    local level  = world:get_level()
                    if level.attributes.mdf then
                        return 500
                    end

                    local mdf_count = 0
                    for e in level:entities() do
                        if e.data and e.data.ai then
                            if e.attributes and e.attributes.mdf and e.attributes.mdf > 0 then
                                mdf_count = mdf_count + 1
                                if mdf_count >= counter then
                                    return 500
                                end
                            end
                        end
                    end
                    local summon = level:add_entity( "mimir_sentry_bot_completionist", level.level_info.entry )
                    world:destroy( summon:child( "mimir_terminal_download" ) )
                    aitk.convert( summon, entity, true, true )
                    summon.attributes.mdf = 1
                    local ai = summon.data.ai
                    ai.state = "idle"
                    ai.idle = "active_hunt"
                    ai.seek = "seek"
                    summon.flags.data[ EF_FOLLOW ] = false
                end
                return 500
            end
        ]],
    },
}

register_blueprint "mimir_terminal_mdf_completionist"
{
    text = {
        entry    = "Reboot MDF",
        disabled = "clearance L1 needed",
        desc     = "Reboot the Mimir Defence Force network.",
    },
    data = {
        terminal = {
            priority      = 0,
            req_attribute = { "mimir_clearance", 1, "disabled"}
        },
    },
    attributes = {
        tool_cost   = 0,
        hacking_mod = 1,
    },
    callbacks = {
        on_activate = [=[
            function( self, who, level )
                local ids = { mimir_sentry_bot_completionist = true, }
                local counter = 0
                for e in level:entities() do 
                    if level:is_alive(e) then
                        if e.data and e.data.ai and e.data.ai.group ~= "player" then
                            if ids[ world:get_id( e ) ] then
                                aitk.convert( e, who, true )
                                counter = counter + 1
                            end
                        end
                    end
                end
                local runtime = who:child( "mimir_shutdown_runtime_completionist" )
                if runtime then
                    runtime.attributes.counter = counter
                end
				
				local common_runtime = who:child( "common_shutdown_runtime_completionist" )
                if runtime then
                    runtime.attributes.mimir_tier = 2
                end

                local parent = self:parent()
                world:destroy( self )
                ui:activate_terminal( who, parent )
                return 100
            end	
        ]=]
    }, 
}

register_blueprint "mimir_terminal_shutdown_completionist"
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
					runtime.attributes.mimir_tier = 1
				else
					common_runtime.attributes.mimir_tier = 1
                end
				who:attach( "mimir_shutdown_runtime_completionist" )                
                for e in level:entities() do 
                    if e.minimap and e.flags and ( e.flags.data[ EF_TARGETABLE ] or e.flags.data[ EF_ACTION ] ) then
                        if e.data and e.data.ai and e.data.ai.group ~= "player" and e.data.is_mechanical then
                            aitk.disable( e, who )
                        end
                    end
                end
                local parent = self:parent()
                world:destroy( self )
                parent:attach( "mimir_terminal_mdf_completionist" )
                ui:activate_terminal( who, parent )
                return 100
            end	
        ]=]
    }, 
}

mimir_central_completionist = {}

function mimir_central_completionist.generate( self, params )
    self:resize( ivec2( 52, 17 ) )
    self:set_styles{ "ts08_C:leather", "ts08_C:leather" }
    generator.fill( self, "wall" )
    local larea = self:get_area():shrinked( 1 )
    self:set_area_style( larea.a, larea.b, 1 )
    generator.archibald_area( self, larea, mimir_central.tileset, { } )
    generator.clear_dual_dead_ends( self )

    local rewards = {
        { "exo_cpistol", "adv_bpistol", "adv_rpistol", "adv_pistol", tier = 2 },
        { "exo_jshotgun", "adv_ashotgun", "adv_dshotgun",  tier = 2 },
        "lootbox_medical",
        "lootbox_armor",
    }
    rewards[1] = generator.episode_unique( self, "uni_revolver_love" ) or rewards[1]
    generator.drop_marker_rewards( self, "mark_special", larea, rewards )

    for c in self:coords( "marker2" ) do
        self:set_cell( c, "floor" )
        local sb = self:add_entity( "mimir_sentry_bot_completionist", c )
        world:destroy( sb:child( "mimir_terminal_download" ) ) 

        local ai = sb.data.ai
        ai.idle  = "wait_and_idle_unless_attacked"
        ai.state = "idle"
        world:set_targetable( sb, false )
        world:remove_from_max_kills( sb )
        sb.attributes.experience_value = 0
        sb.attributes.mdf = 1
        sb.listen.active = false
        sb.minimap.color = 0

        world:destroy( sb:child( "mimir_terminal_download" ) )
        world:destroy( sb:child( "terminal_bot_disable" ) )
        world:destroy( sb:child( "terminal_bot_hack" ) )

        ui:run_animation( sb, "to_off" )

        local drops = {}
        for c in sb:children() do
            if c.flags and c.flags.data[ EF_ITEM ] then
                table.insert( drops, c )
            end
        end
        for _,c in ipairs( drops ) do
            world:destroy( c )
        end


    end

    generator.handle_doors( self, self:get_area(), "marker", "red_locked", { block = true } )
    
    do
        local c = self:find_coord( "mark_turret" )
        self:set_cell( c, "floor" )
        local facing = generator.floor_facing( self, c, self:get_nid( "floor" ) )
        self:place_entity( "terminal_base", c, facing )
        local t = self:place_entity( "terminal", c, facing )
        t:attach( "mimir_terminal_shutdown_completionist" )
    end

    do
        local exo_list = {
            "exo_dpistol",
            "exo_cpistol",
            "exo_fpistol",
            "exo_jpistol",
            "exo_jsmg",
            "exo_tsmg",
            "exo_grenade_launcher",
            "exo_precision_rifle",
            "exo_tac_rifle",
            "exo_toxi_rifle",
            "exo_cshotgun",
            "exo_jshotgun",
            "exo_sshotgun",
        }

        local c = self:find_coord( "marker3" )
        self:set_cell( c, "floor" )
        local facing = generator.floor_facing( self, c, self:get_nid( "floor" ) )
        local ms = self:place_entity( "manufacture_station", c, facing, 2 )
        ms.data.terminal.weapon_prefix = "MDF"
        local sp = ms:attach( "mimir_station_special_manufacture_sub" )
        local list = {}
        local mdf_level = world:get_player():attribute( "mimir_clearance" )
        if mdf_level > 0 then
            ms.attributes.charges = ms.attributes.charges + mdf_level - 1
            local priority = 10
            for _=1,mdf_level * 2 do
                local pick = table.remove( exo_list, math.random( #exo_list ) )
                gtk.add_station_manufacture( sp, pick, 2, priority, 3, "MDF" )
                priority = priority + 10
            end
        end
        sp:attach( "station_back" )
    end
    generator.add_marked_entities( self, mimir_decorations )

    local ar = area( ivec2( 26, 2 ), ivec2( 52, 14 ) )
    generator.generate_litter( self, ar, {
        litter    = { "crate_01", "crate_02", "barrel_fuel",  },
        chance    = 20,
    })

    return { area = larea, no_elevator_check = true, }
end

register_blueprint "level_callisto_calsec_completionist"
{
    blueprint   = "level_base",
	text        = {
        name        = "MDF Central",
    },
    attributes  = {
        level_is_live = 0,
        mdf           = 1,
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
                local attr = self.attributes
                attr.spawn_count = 4 + DIFFICULTY
                attr.spawn_delay = 4
                generator.run( self, nil, mimir_central_completionist.generate, mimir_central.spawn )
                self.environment.lut = math.random_pick( luts.bluegray )
            end
            ]],
        on_enter_level = [[
            function ( self, player, reenter )
                if reenter then
                    for e in self:entities() do 
                        if world:get_id( e ) == "mimir_sentry_bot_completionist" then
                            if e.listen then
                                e.listen.active = false
                            end
                        end
                    end
                    return
                end
                local vo = "vo_callisto_calsec"
                world:play_voice( vo )
                world:special_visited( player, self )
            end
        ]],
        on_cleared = [[
            function ( self )
                local attr = self.attributes
                attr.level_is_live = 2
                world:special_cleared( world:get_player(), self )
            end
        ]],
        is_cleared = [[
            function ( self )
                if self.level_info.enemies > 0 then return 0 end
                local attr = self.attributes
                if attr.level_is_live == 0 then
                    return 0
                end
                return 1
            end
        ]],
        on_move = [[
            function ( self, who, position )
                if who == world:get_player() then
                    local attr  = self.attributes
                    attr.level_is_live = 1
                    local ar = area( ivec2( 2, 5 ), ivec2( 20, 11 ) )
                    if ar:contains( position ) then
                        if attr.spawn_count > 0 then
                            attr.spawn_delay = attr.spawn_delay - 1
                            if attr.spawn_delay < 0 then
                                attr.spawn_delay = 4 - math.min( DIFFICULTY, 2 )
                                attr.spawn_count = attr.spawn_count - 1
                                local list  = {}
                                local level = world:get_level()
                                for e in level:entities() do 
                                    if e.flags and e.data and ( not e.flags.data[ EF_TARGETABLE ] ) and e.flags.data[ EF_ACTION ] and e.data.ai and e.data.ai.group ~= "player" then
                                        if world:get_id( e ) == "mimir_sentry_bot_completionist" then
                                            table.insert( list, e )
                                        end
                                    end
                                end
                                if #list > 0 then
                                    local e = list[ math.random( #list ) ]
                                    world:set_targetable( e, true )
                                    local ai = e.data.ai
                                    ai.idle  = "idle"
                                    ai.state = "wait_and_idle"
                                    world:play_sound( "sentry_bot_idle", e )
                                    ui:run_animation( e, "to_idle" )
                                end
                            end
                        end
                    end
                end
            end
        ]],
        on_create_entity = [[
            function ( level, entity )
                generator.apply_manufacturer( entity, "man_mdf" )
            end
        ]],        
    }
}

