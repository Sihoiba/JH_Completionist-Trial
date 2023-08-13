nova.require "data/lua/core/common"
nova.require "data/lua/core/aitk"
nova.require "data/lua/jh/data/common"

register_blueprint "medusaling_base"
{
	blueprint = "being",
    flags     = { EF_NOMOVE, EF_NOFLY, EF_FLYING, EF_TARGETABLE, EF_ALIVE, },
	health = {},
	sound = {
		idle = "medusa_idle",
		die  = "medusa_die",
		pain = "medusa_pain",
	},
	ascii     = {
		glyph     = "o",
		color     = LIGHTRED,
	},
	attributes = {
		speed = 1.3
		experience_value = 10,
		health           = 10,
		resist = {
			ignite = 100,
			melee = 50
		},
	},
	callbacks = {
		on_attacked = "aitk.on_attacked",
		on_action   = "aitk.standard_ai",
		on_noise    = "aitk.on_noise",
	},
	listen = {
		active   = true,
		strength = 0,
	},
	data = {
		ai = {
			aware  = false,
			alert  = 1,
			group  = "demon",
			state  = "idle",
			melee  = 2,
			charge = true,
			smell  = 2000,
		},
	},
}

register_blueprint "medusaling_jaws"
{
	weapon = {
		group       = "melee",
		type        = "melee",
		natural     = true,
		damage_type = "slash",
		fire_sound  = "medusa_melee",
		hit_sound   = "blunt",
	},
	attributes = {
		damage      = 5,
		crit_damage = 100,
		accuracy    = 25,
		slevel      = { bleed = 1, },
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "apply_bleed" )
		end
		]=],
	}
}

register_blueprint "medusa"
{
	blueprint = "medusaling_base",
	lists = {
		group = "being",
		{    keywords = { "enemy_test", "demon", "demon2" }, weight = 100, dmin = 1, dmax = 24, },		
	},
	text = {
		name      = "medusaling",
		namep     = "medusalings",
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "medusaling_jaws" )
			self:attach( "medusa_dodge" )
		end
		]=],
	},
}