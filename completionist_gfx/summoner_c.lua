register_gfx_blueprint "summoner_c"
{
	entity_fx = {
		on_hit      = "ps_bleed",
		on_critical = "ps_bleed_critical",
	},
	ragdoll  = "ragdoll_warlock",
	animator = "animator_warlock",
	skeleton = "data/model/warlock.nmd",
	scale = { scale = 2.5, },
	render = {
		mesh = "data/model/warlock.nmd:summoner_body_01",
		material = "data/texture/warlock_01/A/summoner_01",
	},
	{
		scale = { scale = 2.5, },
		attach = "CATRigHead",
		render = {
			mesh = "data/model/warlock.nmd:summoner_01_head_01",
			material = "data/texture/warlock_01/A/summoner_01_head_01",
		},
	},

}

register_gfx_blueprint "exalted_summoner_c"
{
	entity_fx = {
		on_hit      = "ps_bleed",
		on_critical = "ps_bleed_critical",
	},
	ragdoll  = "ragdoll_warlock",
	animator = "animator_warlock",
	skeleton = "data/model/warlock.nmd",
	scale = { scale = 3.0, },
	render = {
		mesh = "data/model/warlock.nmd:summoner_body_01",
		material = "data/texture/warlock_01/D/summoner_01",
	},
	{
		scale = { scale = 3.0, },
		attach = "CATRigHead",
		render = {
			mesh = "data/model/warlock.nmd:summoner_01_head_01",
			material = "data/texture/warlock_01/D/summoner_01_head_01",
		},
	},
}