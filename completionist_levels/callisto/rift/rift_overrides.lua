nova.require "data/lua/jh/data/generator"
nova.require "data/lua/jh/data/levels/callisto/rift/rift_tilesets"
nova.require "data/lua/jh/data/levels/callisto/rift/rift_crevice"
nova.require "completionist_levels/callisto/rift/rift_crevice_overrides"
nova.require "completionist_levels/callisto/rift/rift_common_overrides"

register_blueprint "level_callisto_rift_completionist"
{
    blueprint   = "level_base",
    attributes = {
        rift_master = 0,
    },
    callbacks = {
        on_create = [[
            function ( self )
                self.environment.lut = math.random_pick( luts.standard )
                local music = {
                    "music_callisto_06",
                    "music_callisto_07",
                }
                self.environment.music = generator.sequential_pick( music )
                local generate = function( self, params )
                    self:set_styles{ "ts05_A", "ts06_D:ext" }
                    local sets = {
                        { ivec2( 50, 30 ), ivec2( 8, 10 ) },
                        { ivec2( 30, 55 ), ivec2( 12, 8 ) },
                        { ivec2( 60, 25 ), ivec2( 8, 10 ) },
                        { ivec2( 25, 60 ), ivec2( 12, 8 ) },
                    }
                    local set = sets[ math.random( #sets ) ]
                    self:resize( set[1] )
                    params.shrink = set[2]
                    local result = generator.rift_level( self, rift_settings, params )
                    if world.data.pure_generator then return result end
                    local specials = {}
                    for c in self:coords( "mark_special", aarea ) do
                        table.insert( specials, c:clone() )
                    end
                    if #specials > 0 then
                        local sc = specials[ math.random( #specials ) ]
                        self:set_cell( sc, "floor" )
                        self:place_entity( "rift_switch_completionist", sc )
                    end
                    return result
                end

                generator.run( self, nil, generate )
            end
        ]],
        on_create_entity = [[
            function ( level, entity )
                generator.apply_manufacturer( entity, "man_js" )
            end
        ]],
    }
}
