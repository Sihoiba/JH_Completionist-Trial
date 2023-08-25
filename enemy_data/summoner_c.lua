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