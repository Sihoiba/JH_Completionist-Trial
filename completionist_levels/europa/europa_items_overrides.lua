-- Copyright (c) ChaosForge Sp. z o.o.
nova.require "data/lua/core/common"

register_blueprint "permanent_double_backpack"
{
	flags = { EF_NOPICKUP, EF_PERMANENT }, 
	text = {
		name  = "Two CRI backpacks",
		desc  = "Special issue backpacks. Don't leave home without them.\n\n{! * +4 }inventory capacity",
		bdesc = "{!+4} inventory capacity",
	},
	attributes = {
		inv_capacity = 4,
	},
}

register_blueprint "powerup_backpack_completionist"
{
	flags = { EF_ITEM, EF_POWERUP }, 
	text = {
		name = "CRI backpack",
		acquired = "Backpack acquired!",
	},
	ascii     = {
		glyph     = "^",
		color     = LIGHTMAGENTA,
	},
	callbacks = {
		on_enter = [=[
			function( self, entity )
				local attr = entity.attributes
				if attr.is_player then
					ui:set_hint( self.text.acquired, 2001, -3 )
					world:play_sound( "medkit_small", entity )
					ui:spawn_fx( entity, "fx_dash", entity )
					local backpack = entity:child( "permanent_backpack" )
					if backpack then
						world:destroy( backpack )
						entity:attach( "permanent_double_backpack" )
					else
						entity:attach( "permanent_backpack" )
					end	
					return 1 --destroy
				end
				return 0
			end
		]=],
	},
}