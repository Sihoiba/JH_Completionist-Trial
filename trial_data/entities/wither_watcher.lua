register_blueprint "wither_watcher"
{
	blueprint = "watcher_base",
	lists = {
		group    = "being",
		{ keywords = { "enemy_test", "demon", "demon1" }, weight = 100, dmax = 24, },
	},
	attributes = {
		resist = {
			acid   = 50,
			toxin  = 50,
			ignite = 50,
			bleed  = 50,
		},
		experience_value = 100,
		health           = 200,
	},
	text = {
		name      = "wither watcher",
		namep     = "wither watchers",
	},
	callbacks = {
		on_create = [=[
		function( self )
		end
		]=],
		self_destruct = [=[
			function( self )
				if self:child("watcher_suicide") then
					world:destroy( self:child("watcher_suicide") )
					if self.health.current > 0 then	self.health.current = 1 end
					local w = world:create_entity( "watcher_self_destruct" )
					world:attach( self, w )
					world:get_level():fire( self, world:get_position( self ), w, 200 )
				end
			end
		]=],
		on_die = [=[
			function( self, killer, current, weapon )
				if self:child("watcher_suicide") then
					world:lua_callback( self, "self_destruct" )
				end
			end
		]=],
		on_action = [=[
			function( self )
				aitk.standard_ai( self ) 
				local level    = world:get_level()
				if level:is_alive( self ) and self:child( "watcher_suicide" ) then
					local distance = level:distance( self, world:get_player() )
					if distance < 2 then
						world:lua_callback( self, "self_destruct" )
					end
				end
			end
		]=],
		on_post_command = [=[
			function ( actor, cmt, tgt, time )
				local level = world:get_level()
				for b in level:targets( actor, 8 ) do 
					if b.data then
						local data = b.data
						if data.ai and not data.is_mechanical then
							if data.ai.group == "player" or data.ai.group == "cri" then
								world:add_buff( b, "buff_wither", 101, true )
							else
								world:add_buff( b, "buff_watcher_gaze_enemy", 101, true )
							end
						end
					end
				end
			end
		]=],
	},
}