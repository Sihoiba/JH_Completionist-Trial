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
		speed = 1.3,
		experience_value = 10,
		health           = 10,
		resist = {
			ignite = 100,
			melee = 50,
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

register_blueprint "medusaling_curse"
{
	flags = { EF_NOPICKUP, EF_PERMANENT }, 
	text = {
		name  = "Medusaling's venom",
		desc  = "You have been bitten by a medusaling. Some of the wounds it inflicted will never heal.",
		bdesc = "irrecoverable health damage",
	},
	attributes = {
		health_lost = 0,
	},
}

register_blueprint "archmedusaling_jaws"
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
		damage      = 10,
		crit_damage = 100,
		accuracy    = 25,
		slevel      = { bleed = 2, },
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "apply_bleed" )
		end
		]=],
		on_damage = [[
			function ( weapon, who, amount, source )
				if who and who.data and who.data.is_player then
					local curse   = who:child( "medusaling_curse" ) or who:attach( "medusaling_curse" )
					local current = curse.attributes.health_lost
					local hattr   = who.attributes.health
					if current < 30 and hattr > 50 then
						curse.attributes.health_lost = current + 1
						who.attributes.health        = hattr - 1
					end
				end
			end
		]],
	}
}

register_blueprint "medusaling_armor"
{
	armor = {},
	attributes = {
		armor = {
			8,
			slash  = 8,
			pierce = -4,
			plasma = -4,
		},
		health = 200,
	},
	health = {},
}

register_blueprint "medusaling"
{
	blueprint = "medusaling_base",
	lists = {
		group = "being",
		{    5,  keywords = { "enemy_test", "demon", "demon2" }, weight = 100, dmax = 24, },		
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

register_blueprint "archmedusaling"
{
	blueprint = "medusaling_base",
	lists = {
		group = "being",
		{  4,  keywords = {  "enemy_test", "demon", "demon2" }, weight = 100, dmax = 24, },		
	},
	text = {
		name      = "archmedusaling",
		namep     = "archmedusalings",
	},
	data = {
		is_semimechanical = true,
	},
	ascii     = {
		glyph     = "o",
		color     = YELLOW,
	},
	attributes = {
		experience_value = 25,
		speed = 1.4,
		health           = 30,
		resist = {
			emp   = 50,
		},
		damage_mod = {
			emp = 1.0,
		},
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "medusaling_armor" )
			self:attach( "archmedusaling_jaws" )
			self:attach( "medusa_dodge" )
		end
		]=],
	},
}