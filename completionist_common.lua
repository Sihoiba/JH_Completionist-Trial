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

-- COMPLETIONIST DEFINITION

register_blueprint "runtime_completionist"
{
    flags = { EF_NOPICKUP },
    callbacks = {
        on_enter_level = [[
            function ( self, player, reenter )
                nova.log("Level: "..world:get_level().text.name.." level number "..tostring(world.data.current).." depth: "..tostring(world:get_level().level_info.depth).." reenter "..tostring(reenter))
                nova.log("kills total, kills max "..tostring(player.statistics.data.kills_total())..","..tostring(player.statistics.data.kills_max()))

                if world.data.current == 93 then
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
                    local unlocked = {1,9,17,25,26,27,31,32,34,35,38,39,42,43,46,47,50,51,54,55,58,59,62,63,66,67,70,71,74,75,78,79,82,92}
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
                nova.log("Runtime completionist completed successfully")
            end
        ]]
    },
}

function killOnSight(self, being, player)
    if being.data and being.data.ai.group ~= "player" and not being.data.is_mechanical then
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