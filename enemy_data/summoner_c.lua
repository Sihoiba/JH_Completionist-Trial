register_blueprint "summoner_c"
{
    blueprint = "summoner",
    text = {
        name      = "Summoner",
        namep     = "Summoners",
    },
    callbacks = {
        on_die = [[
            function( self )
                world:play_sound( "boss_die", self )
                ui:set_hint( self.text.on_portal, 5000, -3 )
                world:play_voice( "vo_beyond_arena" )
            end
        ]],
    }
}

register_blueprint "exalted_summoner_c"
{
    blueprint = "summoner_c",
    data = {
        buff = "buff_exalted_summoning",
        ai = {
            exalted = true,
        },
    },
}