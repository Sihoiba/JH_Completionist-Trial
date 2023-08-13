register_blueprint "printed_drone"
{
	blueprint = "drone_base",
	lists = {
		group = "being",
		{ keywords = {"drone", "robotic", "civilian" } },
	},
	text = {
		name      = "security drone",
		namep     = "security drones",
		entry     = "Drone",
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "drone_weapon_1" )			
			local hack    = self:attach( "terminal_bot_hack" )
			hack.attributes.tool_cost = 3
			local disable = self:attach( "terminal_bot_disable" )
			disable.attributes.tool_cost = 1
			self:attach( "terminal_return" )
		end
		]=],
		on_die = [=[
			function( self, killer, current, weapon )
				if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
				world:play_sound( "explosion", self, 0.3 )
				ui:spawn_fx( nil, "fx_drone_explode", nil, world:get_position( self ) )
				self.attributes.parent.attributes.print_count = self.attributes.parent.attributes.print_count - 1
			end
		]=],
	},
	attributes = {
		experience_value = 0,
		accuracy = -10,
		health   = 10,
		parent = nil,
	},
}

register_blueprint "drone_printer_self_destruct"
{
	attributes = {
		damage    = 30,
		explosion = 3,
	},
	weapon = {
		group = "env",
		damage_type = "slash",
		natural = true,
		fire_sound = "explosion",
	},
	noise = {
		use = 15,
	},
}

register_blueprint "drone_printer"
{
	blueprint = "bot",
	lists = {
		group = "being",
		{  4,  keywords = {  "enemy_test", "bot", "robotic", "civilian" }, weight = 100, dmax = 24, },		
	},
	flags = { EF_NOMOVE, EF_NOFLY, EF_TARGETABLE, EF_ALIVE, },
    text = {
		name      = "Drone Printer",
		namep     = "Drone Printers",
	},
	sound = {
		idle = "tank_mech_idle",
		step = "tank_mech_step",
		die  = "tank_mech_die",
	},
    ascii     = {
		glyph     = "p",
		color     = WHITE,
	},
	data = {
		ai = {
			aware     = false,
			alert     = 1,
			group     = "security",
			state     = "idle",
            range     = 6,            
		},        
	},
    attributes = {
		evasion = -20,
		speed            = 0.9,
        health           = 100,
        experience_value = 50,
		resist = {
			emp = 25,
		},
		print_id = "printed_drone",
		print_count = 0,
		print_max = 10,
	},
    state = "open",
    inventory = {},
    callbacks = {    
		on_create = [=[
			function( self )				
				local hack    = self:attach( "terminal_bot_hack" )
				hack.attributes.tool_cost = 10
				local disable = self:attach( "terminal_bot_disable" )
				disable.attributes.tool_cost = 5
				self:attach( "terminal_return" )
			end
			]=],		 
        on_load = [=[
            function ( self )
                world:get_level():rotate_towards( self, world:get_player() )
            end
        ]=],               		
		on_action   = [=[
            function( self )
                aitk.standard_ai( self )
				if self.attributes.print_count < self.attributes.print_max then
					world:play_sound( "armor_shard", self )
					local ar = area.around(world:get_position( self ), 1 )
					ar:clamp( world:get_level():get_area() )
					local c = generator.random_safe_spawn_coord( world:get_level(), ar, world:get_position( self ), 1 )
					local s = world:get_level():add_entity("printed_drone", c, nil )
					s.attributes.parent = self
					self.attributes.print_count = self.attributes.print_count + 1
				end											
            end
        ]=],
		on_noise    = "aitk.on_noise",
        on_die = [=[
		function( self, killer, current, weapon )
			if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
			local w = world:create_entity( "drone_printer_self_destruct" )
			world:attach( self, w )
			world:get_level():fire( self, world:get_position( self ), w )
		end
		]=],
		on_activate = [=[
			function( self, who, level, param )
				if who == world:get_player() then
					world:play_sound( "ui_terminal_accept", self )
					ui:activate_terminal( who, self, uitk.hack_activate_params( self ) )
					return 0
				else 
					return 0
				end
			end
		]=],
	},  
}
