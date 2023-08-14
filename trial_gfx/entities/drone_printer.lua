register_gfx_blueprint "printed_drone"
{
	blueprint = "drone_base",
	scale = {
		scale = 0.5,
	},
	style = {
		materials = {
			drone = "data/texture/drone_01/A/drone_01_A",
		},
	},
}

register_gfx_blueprint "printed_combat_drone"
{
	blueprint = "drone_base",
	scale = {
		scale = 0.7,
	},
	style = {
		materials = {
			drone = "data/texture/drone_01/B/drone_01_B",
		},
	},
}

register_gfx_blueprint "printed_military_drone"
{
	blueprint = "drone_base",
	scale = {
		scale = 0.8,
	},
	style = {
		materials = {
			drone = "data/texture/drone_01/C/drone_01_C",
		},
	},
}


register_gfx_blueprint "drone_printer"
{
	ragdoll  = "ragdoll_tank_mech",
	animator = "animator_tank_mech",
	skeleton = "data/model/tank_mech_01.nmd",
	rotation = {
		pivot = "RigHead1",
		range = 100,
		keep  = true,
    },
    movement = {
        no_rotate = true,
    },
    scale = {
        scale = 0.4
    },
    {
        scene = {},
		scale = {
			scale = 0.4
		},
        render = {
            mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01",
            material    = "data/texture/tank_mech_01/A/tank_mech_body_01",
        },	
        {
            scene = {},
			scale = {
				scale = 0.4
			},
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#01",
                material    = "data/texture/tank_mech_01/A/tank_mech_head_01",
            },	
        },
        {
            scene = {},
			scale = {
				scale = 0.4
			},
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#02",
                material    = "data/texture/tank_mech_01/A/tank_mech_legs_01",
            },	
        },
    }
}

register_gfx_blueprint "combat_drone_printer"
{
	ragdoll  = "ragdoll_tank_mech",
	animator = "animator_tank_mech",
	skeleton = "data/model/tank_mech_01.nmd",
	rotation = {
		pivot = "RigHead1",
		range = 100,
		keep  = true,
    },
    movement = {
        no_rotate = true,
    },
    scale = {
        scale = 0.5
    },
    {
        scene = {},
		scale = {
			scale = 0.5
		},
        render = {
            mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01",
            material    = "data/texture/tank_mech_01/A/tank_mech_body_01",
        },	
        {
            scene = {},
			scale = {
				scale = 0.5
			},
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#01",
                material    = "data/texture/tank_mech_01/A/tank_mech_head_01",
            },	
        },
        {
            scene = {},
			scale = {
				scale = 0.5
			},
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#02",
                material    = "data/texture/tank_mech_01/A/tank_mech_legs_01",
            },	
        },
    }
}

register_gfx_blueprint "military_drone_printer"
{
	ragdoll  = "ragdoll_tank_mech",
	animator = "animator_tank_mech",
	skeleton = "data/model/tank_mech_01.nmd",
	rotation = {
		pivot = "RigHead1",
		range = 100,
		keep  = true,
    },
    movement = {
        no_rotate = true,
    },
    scale = {
        scale = 0.55
    },
    {
        scene = {},
		scale = {
			scale = 0.55
		},
        render = {
            mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01",
            material    = "data/texture/tank_mech_01/A/tank_mech_body_01",
        },	
        {
            scene = {},
			scale = {
				scale = 0.55
			},
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#01",
                material    = "data/texture/tank_mech_01/A/tank_mech_head_01",
            },	
        },
        {
            scene = {},
			scale = {
				scale = 0.55
			},
            render = {
                mesh        = "data/model/tank_mech_01.nmd:tank_mech_body_01#02",
                material    = "data/texture/tank_mech_01/A/tank_mech_legs_01",
            },	
        },
    }
}