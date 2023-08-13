register_blueprint "fiend_acidclaws"
{
	weapon = {
		group = "melee",
		type  = "melee",
		natural = true,
		damage_type = "slash",
		fire_sound = "fiend_melee",
		hit_sound  = "blunt",
	},
	attributes = {
		damage      = 10,
		accuracy    = 20,
		slevel      = { bleed = 3, },
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "apply_bleed" )
		end
		]=],
	},	
}

register_blueprint "arch_fiend"
{
	blueprint = "fiend_base",
	lists = {
		group = "being",
		{ 2, keywords = { "enemy_test", "demon", "demon1" }, weight = 50, dmax = 24, },
	},
	text = {
		name      = "arch fiend",
		namep     = "arch fiends",
	},
	callbacks = {
		on_create = [=[
		function( self )
			self:attach( "fiend_acidclaws" )
		end
		]=],
		on_die = [=[
			function( self, killer, current, weapon )
				local p = world:get_position( self )
				local level = world:get_level()
				local nlist  = { coord( p.x - 1, p.y - 1 ), coord( p.x , p.y - 1), coord( p.x + 1, p.y - 1 ), coord( p.x - 1, p.y ), p, coord( p.x + 1, p.y ), coord( p.x - 1, p.y + 1 ), coord( p.x , p.y + 1), coord( p.x + 1, p.y + 1 )}
				for _,c in ipairs( nlist ) do
					local pool = level:get_entity(c, "acid_pool" )
					if not pool then
						pool = level:place_entity( "acid_pool", c )
					end
					pool.attributes.acid_amount = 10
					pool.lifetime.time_left = math.max( pool.lifetime.time_left, 400 + math.random(100) )
				end
				
			end
		]=],
	},
	attributes = {
		speed = 1.25,
		experience_value = 50,
		health   = 50,
		accuracy = 10,
		resist = {
			melee = 25,
			slash = 25,
			impact = 25,
			fire = 50,
			acid = 100,
		},
	},
}