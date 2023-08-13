register_gfx_blueprint "medusaling_base_flesh"
{
	entity_fx = {
		on_hit      = "ps_bleed",
		on_critical = "ps_bleed_critical",
	},
	ragdoll = "ragdoll_medusa",
	animator = "animator_medusa",
	skeleton = "data/model/medusa_01.nmd",
	movement = {
		floating = 0.6,
	},	
	scale = {
		scale = 0.3,
	},
	render = {
		mesh        = "data/model/medusa_01.nmd:medusa_body_01",
		material    = "medusa_body",
	},
	{	
		scale = {
			scale = 0.3,
		},
		render = {
			mesh        = "data/model/medusa_01.nmd:medusa_tentacles_02",
			material    = "medusa_tentacles_02",
		},
	},
	{		
		scale = {
			scale = 0.3,
		},
		render = {
			mesh        = "data/model/medusa_01.nmd:medusa_addon_01",
			material    = "medusa_addon",
		},
	},
	{	
		scale = {
			scale = 0.3,
		},
		render = {
			mesh        = "data/model/medusa_01.nmd:medusa_weapon_01",
			material    = "medusa_weapon",
		},
	},
}

register_gfx_blueprint "medusaling_base_metal"
{
	entity_fx = {
		on_hit      = "ps_bleed",
		on_critical = "ps_bleed_critical",
	},
	ragdoll = "ragdoll_medusa",
	animator = "animator_medusa",
	skeleton = "data/model/medusa_01.nmd",
	movement = {
		floating = 0.6,
	},	
	scale = {
		scale = 0.4,
	},
	render = {
		mesh        = "data/model/medusa_01.nmd:medusa_body_01",
		material    = "medusa_body",
	},
	{	
		scale = {
			scale = 0.4,
		},
		render = {
			mesh        = "data/model/medusa_01.nmd:medusa_tentacles_02",
			material    = "medusa_tentacles_02",
		},
	},
	{		
		scale = {
			scale = 0.4,
		},
		render = {
			mesh        = "data/model/medusa_01.nmd:medusa_addon_01",
			material    = "medusa_addon",
		},
	},
	{	
		scale = {
			scale = 0.4,
		},
		render = {
			mesh        = "data/model/medusa_01.nmd:medusa_weapon_01",
			material    = "medusa_weapon",
		},
	},
}

register_gfx_blueprint "medusaling"
{
	blueprint = "medusaling_base_flesh",
	style = {
		materials = {
			medusa_body         = "data/texture/medusa_01/A/medusa_body_01",
			medusa_addon        = "data/texture/medusa_01/A/medusa_addon_01",
			medusa_tentacles_01 = "data/texture/medusa_01/A/medusa_tentacles_01",
			medusa_tentacles_02 = "data/texture/medusa_01/A/medusa_tentacles_02",
			medusa_weapon       = "data/texture/medusa_01/A/medusa_weapon_01",
		},
	},
}

register_gfx_blueprint "archmedusaling"
{
	blueprint = "medusaling_base_metal",
	style = {
		materials = {
			medusa_body         = "data/texture/medusa_01/B/medusa_body_01",
			medusa_addon        = "data/texture/medusa_01/B/medusa_addon_01",
			medusa_tentacles_01 = "data/texture/medusa_01/B/medusa_tentacles_01",
			medusa_tentacles_02 = "data/texture/medusa_01/B/medusa_tentacles_02",
			medusa_weapon       = "data/texture/medusa_01/B/medusa_weapon_01",
		},
	},
}