nova.require "data/lua/jh/main"

-- Override methods that can cause crashes

function gtk.place_flames( p, amount, delay, flame_info )
    local flame_info = flame_info or {
        id  = "flames",
        pid = "permaflames",
    }
    local level = world:get_level()
    if not level:get_cell_flags( p )[ EF_NOMOVE ] then
        local pool  = level:get_entity( p, flame_info.id ) or level:get_entity( p, flame_info.pid )
        if not pool then
            pool = level:place_entity( flame_info.id, p )
            if pool then
                pool.attributes.amount = amount
                if delay then
                    delay = delay * 0.001
                    ui:run_visual_event( pool, "set_value", "burning1", { component = "particle_emitter_node", key = "pause",  value = delay, } )
                    ui:run_visual_event( pool, "set_value", "burning1", { component = "particle_emitter_node", key = "active", value = false, } )
                    ui:run_visual_event( pool, "set_value", "burning2", { component = "particle_emitter_node", key = "pause",  value = delay, } )
                    ui:run_visual_event( pool, "set_value", "burning2", { component = "particle_emitter_node", key = "active", value = false, } )
                end
            else
                nova.log("ERROR: Place flames failed to create flames")
            end
        else
            pool.attributes.amount = math.max( pool.attributes.amount, amount )
        end
    end
end

function gtk.place_smoke( c, duration )
    gtk.remove_fire( c )
    local level = world:get_level()
    world:destroy( level:entity_find( c, "toxic_smoke" ) )
    world:destroy( level:entity_find( c, "freeze_smoke" ) )
    world:destroy( level:entity_find( c, "toxic_smoke_cloud" ) )
    world:destroy( level:entity_find( c, "freeze_smoke_cloud" ) )
    local smoke = level:get_entity( c, "smoke" )
    if not smoke then
        smoke = level:place_entity( "smoke", c )
    end
    if smoke then
        world:set_scent( c, 0 )
        smoke.lifetime.time_left = math.max( smoke.lifetime.time_left, duration )
    else
        nova.log("ERROR: Place smoke failed to create smoke")
    end
end

function gtk.place_toxic_smoke( c, duration, amount )
    gtk.remove_fire( c )
    local level = world:get_level()
    world:destroy( level:entity_find( c, "smoke" ) )
    world:destroy( level:entity_find( c, "freeze_smoke" ) )
    world:destroy( level:entity_find( c, "smoke_cloud" ) )
    world:destroy( level:entity_find( c, "freeze_smoke_cloud" ) )
    local smoke = level:get_entity( c, "toxic_smoke" )
    if not smoke then
        smoke = level:place_entity( "toxic_smoke", c )
    end
    if smoke then
        world:set_scent( c, 0 )
        smoke.attributes.poison_amount = math.max( smoke.attributes.poison_amount, amount )
        smoke.lifetime.time_left       = math.max( smoke.lifetime.time_left, duration )
    else
        nova.log("ERROR: Place toxic smoke failed to create smoke")
    end
end

function gtk.place_freeze_smoke( c, duration, amount )
    gtk.remove_fire( c )
    local level = world:get_level()
    world:destroy( level:entity_find( c, "smoke" ) )
    world:destroy( level:entity_find( c, "smoke_cloud" ) )
    world:destroy( level:entity_find( c, "toxic_smoke" ) )
    world:destroy( level:entity_find( c, "toxic_smoke_cloud" ) )
    local smoke = level:get_entity( c, "freeze_smoke" )
    if not smoke then
        smoke = level:place_entity( "freeze_smoke", c )
    end
    if smoke then
        world:set_scent( c, 0 )
        smoke.attributes.cold_amount = math.max( smoke.attributes.cold_amount, amount )
        smoke.lifetime.time_left     = math.max( smoke.lifetime.time_left, duration )
    else
        nova.log("ERROR: Place freeze smoke failed to create smoke")
    end
end