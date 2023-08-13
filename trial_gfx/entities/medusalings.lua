nova.require "data/lua/gfx/common"

register_gfx_blueprint "medusaling"
{
	blueprint = "medusa_base_flesh",
	style = {
		materials = {
			medusa_body         = "data/texture/medusa_01/A/medusa_body_01",
			medusa_addon        = "data/texture/medusa_01/A/medusa_addon_01",
			medusa_tentacles_01 = "data/texture/medusa_01/A/medusa_tentacles_01",
			medusa_tentacles_02 = "data/texture/medusa_01/A/medusa_tentacles_02",
			medusa_weapon       = "data/texture/medusa_01/A/medusa_weapon_01",
		},
	},
	scale = {
		scale = 0.3,
	},
}
