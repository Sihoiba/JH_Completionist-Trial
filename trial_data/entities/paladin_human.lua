register_blueprint "human_paladin_machete"
{
	blueprint = "zombie",
	lists = {
		group    = "being",
		{ keywords = { "enemy_test",  "former", "former2", "civilian" }, weight = 100, dmax = 24, },
	},
	text = {
		name      = "corrupted paladin",
		namep     = "corrupted paladins",
	},
	callbacks = {
		on_create = [=[
		function( self, level )
			self:attach( "riot_shield" )
			self:attach( "machete" )
			if level.level_info.low_light then
				self:attach( "npc_flashlight" )
			end
		end
		]=],
	},
	attributes = {
		speed            = 0.9,
		experience_value = 30,
		accuracy         = 10,
		health           = 40,
		resist = {
			melee = 75,
			slash = 75,			
		},
	},
	data = {
		ai = {
			cover = false,
		},
	},
}

register_blueprint "human_paladin_sword"
{
	blueprint = "zombie",
	lists = {
		group    = "being",
		{ keywords = { "enemy_test",  "former", "former4", "civilian" }, weight = 100, dmax = 24, },
	},
	text = {
		name      = "former CRI paladin",
		namep     = "former CRI paladins",
	},
	callbacks = {
		on_create = [=[
		function( self, level )
			self:attach( "riot_shield" )
			self:attach( "katana" )
			self:attach( "security_light_armor" )
			if level.level_info.low_light then
				self:attach( "npc_flashlight" )
			end
		end
		]=],
	},
	attributes = {
		speed            = 0.9,
		experience_value = 30,
		accuracy         = 10,
		health           = 45,
		resist = {
			melee = 75,
			slash = 75,			
		},
	},
	data = {
		ai = {
			cover = false,
		},
	},
}

register_blueprint "human_paladin_chainsaw"
{
	blueprint = "zombie",
	lists = {
		group    = "being",
		{ keywords = { "enemy_test",  "former", "former3", "civilian" }, weight = 100, dmax = 24, },
	},
	text = {
		name      = "hellish paladin",
		namep     = "hellish paladins",
	},
	callbacks = {
		on_create = [=[
		function( self, level )
			self:attach( "riot_shield" )
			self:attach( "security_heavy_armor" )
			self:attach( "chainsaw" )
			if level.level_info.low_light then
				self:attach( "npc_flashlight" )
			end
		end
		]=],
	},
	attributes = {
		speed            = 0.9,
		experience_value = 30,
		accuracy         = 10,
		health           = 50,
		resist = {
			melee = 75,
			slash = 75,			
		},
	},
	data = {
		ai = {
			cover = false,
		},
	},
}