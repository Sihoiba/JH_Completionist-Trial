nova.require "data/lua/jh/data/generator"

 -- MAKE CALLISTO REWARDS NOT SPREAD EVERYWHERE ON COMPLETIONIST
register_blueprint "rift_perm_level_completionist"
{
    flags = { EF_NOPICKUP },
    attributes = {
        rift_level = 1,
    },
    callbacks = {
        on_enter_level = [=[
            function ( self, entity, reenter )
                local current_id = world.data.current
                local current    = world.data.level[ current_id ]
                if current.episode > 1 then
                    world:mark_destroy( self )
                    return
                end
                if current_id > 8 then
                    return
                end
                if not reenter and self.attributes.rift_level == 10 then
                    local count = 12
                    local ppos  = world:get_position( entity )
                    local level = world:get_level()
                    for _=1,count do
                        local c
                        local tries = 0
                        repeat
                            c = generator.random_safe_spawn_coord( level, level:get_area(), who, 8 )
                            tries = tries + 1
                        until not level:get_entity(c) or tries > 99
                        if not level:get_entity(c) then
                            local ent = world:create_entity( "toxic_smoke_cloud" )
                            level:drop_entity( ent , c )
                        end
                    end
                end
            end
        ]=],
    },
}

register_blueprint "rift_switch_completionist"
{
    flags = { EF_NOMOVE, EF_BUMPACTION, EF_ACTION, EF_HARD_COVER },
    text = {
        name      = "gas valve",
        confirm   = "Are you sure you want to open the gas pipeline?",
        nothing   = "Nothing happens, the pipeline seems empty"
    },
    ascii     = {
        glyph     = "&",
        color     = LIGHTGREEN,
    },
    minimap   = {
        color  = tcolor( GREEN, ivec3( 0, 128, 0 ) ),
        reveal = true,
    },
    attributes = {},
    state = "closed",
    callbacks = {
        on_activate = [=[
        function( self, who, level, param, id )
            if who == world:get_player() then
                if id == world:hash("confirm") then
                    world:set_state( self, "open" )
                    self.flags.data = { EF_NOMOVE, EF_HARD_COVER }
                    world:play_sound( "ui_terminal_accept", self )
                    local stage = 0
                    local child = who:child( "rift_perm_level_completionist" )
                    if ( level.attributes.rift_master or 0 ) > 0 then
                        if (not child) or child.attributes.rift_level < 2 then
                            ui:set_hint( "{R"..self.text.nothing.."}", 2001, 0 )
                            return 1
                        end
                        child.attributes.rift_level = 10
                        stage = (level.attributes.stage or 0)
                        world:lua_callback( world:get_level(), "on_switch" )
                    else
                        if not child then
                            who:attach( "rift_perm_level_completionist" )
                        else
                            child.attributes.rift_level = child.attributes.rift_level + 1
                        end
                    end
                    local count = 8 + stage * 8
                    local ppos  = world:get_position( who )
                    for _=1,count do
                        local c
                        local tries = 0
                        repeat
                            c = generator.random_safe_spawn_coord( level, level:get_area(), who, 8 )
                            tries = tries + 1
                        until not level:get_entity(c) or tries > 99
                        if not level:get_entity(c) then
                            local ent = world:create_entity( "toxic_smoke_cloud" )
                            level:drop_entity( ent , c )
                        end
                    end
                    return 1
                else
                    ui:confirm {
                        size    = ivec2( 30, 8 ),
                        content = self.text.confirm,
                        actor   = who,
                        target  = self,
                        command = COMMAND_ACTIVATE,
                    }
                    return -1
                end
            else
                return 0
            end
        end
        ]=],
    },
}