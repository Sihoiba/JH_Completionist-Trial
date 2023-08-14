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
	data = {
		parent = nil,
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "drone_weapon_1" )		
			self:attach( "ammo_9mm", { stack = { amount = 1 + math.random(1) } } )		
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
				self.data.parent.data.print_count = self.data.parent.data.print_count - 1
			end
		]=],
	},
	attributes = {
		experience_value = 0,
		accuracy = -10,
		health   = 10,		
	},
}

register_blueprint "printed_combat_drone"
{
	blueprint = "drone_base",
	lists = {
		group = "being",
		{ keywords = {"drone", "robotic", "civilian" } },
	},
	text = {
		name      = "combat drone",
		namep     = "combat drones",
		entry     = "Drone",
	},
	data = {
		parent = nil,
	},
	ascii     = {
		glyph     = "^",
		color     = YELLOW,
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "drone_weapon_2" )
			self:attach( "ammo_9mm", { stack = { amount = 2 + math.random(1) } } )
			local hack    = self:attach( "terminal_bot_hack" )
			hack.attributes.tool_cost = 4
			local disable = self:attach( "terminal_bot_disable" )
			disable.attributes.tool_cost = 2
			self:attach( "terminal_return" )
		end
		]=],
		on_die = [=[
			function( self, killer, current, weapon )
				if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
				world:play_sound( "explosion", self, 0.3 )
				ui:spawn_fx( nil, "fx_drone_explode", nil, world:get_position( self ) )
				self.data.parent.data.print_count = self.data.parent.data.print_count - 1
			end
		]=],
	},
	attributes = {
		experience_value = 0,
		accuracy = 0,
		health   = 20,
	},
}

register_blueprint "printed_military_drone"
{
	blueprint = "drone_base",
	lists = {
		group = "being",
		{ keywords = {"drone", "robotic", "civilian" } },
	},
	text = {
		name      = "military drone",
		namep     = "military drones",
		entry     = "Drone",
	},
	ascii     = {
		glyph     = "^",
		color     = WHITE,
	},
	data = {
		parent = nil,
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "drone_weapon_3" )	
			self:attach( "ammo_762", { stack = { amount = 2 + math.random(1) } } )			
			local hack    = self:attach( "terminal_bot_hack" )
			hack.attributes.tool_cost = 5
			local disable = self:attach( "terminal_bot_disable" )
			disable.attributes.tool_cost = 3
			self:attach( "terminal_return" )
		end
		]=],
		on_die = [=[
			function( self, killer, current, weapon )
				if weapon and weapon.weapon and weapon.weapon.type == world:hash("melee") then return end
				world:play_sound( "explosion", self, 0.3 )
				ui:spawn_fx( nil, "fx_drone_explode", nil, world:get_position( self ) )
				self.data.parent.data.print_count = self.data.parent.data.print_count - 1
			end
		]=],
	},
	attributes = {
		experience_value = 0,
		accuracy = 10,
		health   = 30,
	},
}

register_blueprint "drone_printer_self_destruct"
{
	attributes = {
		damage    = 30,
		explosion = 2,
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
		{  keywords = { "enemy_test", "bot", "robotic", "civilian" }, weight = 100, dmax = 24, },		
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
		print_id = "printed_drone",
		print_count = 0,
		print_max = 10,
		print_delay = 0;
	},
    attributes = {
		evasion = -20,
		speed            = 0.9,
        health           = 100,
        experience_value = 50,
		resist = {
			emp = 25,
		},
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
				if self.data.print_count < self.data.print_max then
					if self.data.print_delay < 3 then
						self.data.print_delay = self.data.print_delay + 1
						return
					end
					self.data.print_delay = 0
					world:play_sound( "armor_shard", self )
					local ar = area.around(world:get_position( self ), 1 )
					ar:clamp( world:get_level():get_area() )
					local c = generator.random_safe_spawn_coord( world:get_level(), ar, world:get_position( self ), 1 )
					local s = world:get_level():add_entity(self.data.print_id, c, nil )
					s.data.parent = self					
					self.data.print_count = self.data.print_count + 1
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

register_blueprint "combat_drone_printer"
{
	blueprint = "bot",
	lists = {
		group = "being",
		{  keywords = {  "enemy_test", "bot", "robotic", "civilian" }, weight = 100, dmax = 24, },		
	},
	flags = { EF_NOMOVE, EF_NOFLY, EF_TARGETABLE, EF_ALIVE, },
    text = {
		name      = "Combat Drone Printer",
		namep     = "Combat Drone Printers",
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
		print_id = "printed_combat_drone",
		print_count = 0,
		print_max = 10,
		print_delay = 0;
	},
    attributes = {
		evasion = -20,
		speed            = 0.9,
        health           = 150,
        experience_value = 75,
		resist = {
			emp = 25,
		},
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
				self:attach( "sentry_bot_chaingun" )
				self:attach( "ammo_762", { stack = { amount = 5 + math.random(5) } } )
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
				if self.data.print_count < self.data.print_max then
					if self.data.print_delay < 3 then
						self.data.print_delay = self.data.print_delay + 1
						return
					end
					self.data.print_delay = 0
					world:play_sound( "armor_shard", self )
					local ar = area.around(world:get_position( self ), 1 )
					ar:clamp( world:get_level():get_area() )
					local c = generator.random_safe_spawn_coord( world:get_level(), ar, world:get_position( self ), 1 )
					local s = world:get_level():add_entity(self.data.print_id, c, nil )
					s.data.parent = self					
					self.data.print_count = self.data.print_count + 1
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

register_blueprint "military_drone_printer"
{
	blueprint = "bot",
	lists = {
		group = "being",
		{  keywords = {  "enemy_test", "bot", "robotic", "civilian" }, weight = 100, dmax = 24, },		
	},
	flags = { EF_NOMOVE, EF_NOFLY, EF_TARGETABLE, EF_ALIVE, },
    text = {
		name      = "Military Drone Printer",
		namep     = "Military Drone Printers",
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
		print_id = "printed_military_drone",
		print_count = 0,
		print_max = 10,
		print_delay = 0;
	},
    attributes = {
		evasion = -20,
		speed            = 0.9,
        health           = 200,
        experience_value = 100,
		resist = {
			emp = 25,
		},
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
				self:attach( "tank_mech_auto" )
				self:attach( "ammo_762", { stack = { amount = 10 + math.random(5) } } )
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
				if self.data.print_count < self.data.print_max then
					if self.data.print_delay < 3 then
						self.data.print_delay = self.data.print_delay + 1
						return
					end
					self.data.print_delay = 0
					world:play_sound( "armor_shard", self )
					local ar = area.around(world:get_position( self ), 1 )
					ar:clamp( world:get_level():get_area() )
					local c = generator.random_safe_spawn_coord( world:get_level(), ar, world:get_position( self ), 1 )
					local s = world:get_level():add_entity(self.data.print_id, c, nil )
					s.data.parent = self					
					self.data.print_count = self.data.print_count + 1
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