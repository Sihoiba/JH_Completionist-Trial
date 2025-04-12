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
                nova.log("Place flames failed to create flames")
            end
        else
            pool.attributes.amount = math.max( pool.attributes.amount, amount )
        end
    end
end

