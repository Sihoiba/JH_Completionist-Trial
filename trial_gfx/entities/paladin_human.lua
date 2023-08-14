nova.require "data/lua/gfx/common"
nova.require "data/lua/jh/gfx/entities/human"
nova.require "data/lua/jh/gfx/items/riot_shield"
nova.require "data/lua/jh/gfx/weapons/melee"

register_gfx_blueprint "animator_human_paladin_machete"
{
	pose_animator   = "data/model/human_male_poses.nmd",
	{
		pose_layer = {
			name    = "base",
			default = "idle",
		},
		{
			pose_state = {
				name        = "idle",
				pose_set    = "human_male_shield_armed_idle",
			},
			pose_transition = { 
				{ name = "to_run", target = "run", duration  = 0.2 },
			},
		},
		{
			pose_state = {
				name = "run",
				pose_set = "human_male_shield_armed_run", 
				duration = 0.5,
			},
			pose_transition = { 
				{ name = "to_idle", target = "idle", duration  = 0.2 },
			}
		},
	},
	{	
		pose_layer = {
			name = "upper",
			mask = "RigSpine1",
			default = "machete",
		},
		{
			pose_state = {
				name = "machete",
			},
			pose_transition = { 
				{ name = "to_machete",     target = "machete",     duration = 0.2, },
				{ name = "to_melee",  target = "machete_melee_01", duration = 0.03, ease_in_out = EASING_BACK, },
				{ name = "to_melee2", target = "machete_melee_02", duration = 0.03, ease_in_out = EASING_BACK, },
			}
		},
		{
			pose_state = {
				name      = "machete_melee_01",
				pose_set  = "human_male_machete_attack_01",
				duration  = 0.4,
				start     = 0,
				stop      = 3,
				loop      = false,
				on_finish = "to_done",
			},
			pose_transition = { 
				{ name = "to_done",  target = "machete", duration = 0.2, },
			},
		},
		{
			pose_state = {
				name      = "machete_melee_02",
				pose_set  = "human_male_machete_attack_02",
				duration  = 0.4,
				start     = 0,
				stop      = 3,
				loop      = false,
				on_finish = "to_done",
			},
			pose_transition = { 
				{ name = "to_done",  target = "machete", duration = 0.2, },
			},
		},	
	},	
}

register_gfx_blueprint "human_paladin_machete"
{
	blueprint = "security_base",
	animator = "animator_human_paladin_machete",
	style = {
		materials = {
			security_shield       = "data/texture/weapons/riot_shield_01/riot_shield_01_A",
			security_knees        = "data/texture/security/europa_regular/security_knees_01",
			security_elbows       = "data/texture/security/europa_regular/security_elbows_01",
			security_purse        = "data/texture/security/europa_regular/security_purse_01",
			security_helmet       = "data/texture/security/europa_regular/security_helmet_01",
			security_helmet_glass = "data/texture/security/europa_regular/security_helmet_glass_01",
			security_body_A       = "data/texture/security/europa_regular/security_body_01_A",
            security_body_B       = "data/texture/security/europa_regular/security_body_01_B",
            security_body_C       = "data/texture/security/europa_regular/security_body_01_C",
		},
	},
	"pf_security_helmet_01",
	"pf_security_knees",
	"pf_security_elbows",
	"pf_security_purse",
	"pf_security_body_ABC",
}