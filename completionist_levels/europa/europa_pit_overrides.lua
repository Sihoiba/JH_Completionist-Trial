nova.require "data/lua/jh/data/generator"
nova.require "data/lua/jh/data/levels/europa/europa_pit"
nova.require "completionist_levels/europa/europa_items_overrides"

europa_pit_completionist = {}

function europa_pit_completionist.generate( self, params )
	self:resize( ivec2( 49, 49 ) )
	self:set_styles{ "ts09_E", "ts06_C:ext" }
	generator.fill( self, "wall" )
	local result = generator.archibald_area( self, self:get_area():shrinked(1), europa_pit.rooms, {} )

	result.no_elevator_check = true

	-- Place terminals
	local area_1 = area( ivec2( 17, 0  ), ivec2( 31, 21 ) )
	local area_2 = area( ivec2( 17, 25 ), ivec2( 31, 47 ) )
	local area_3 = area( ivec2( 0 , 17 ), ivec2( 22, 31 ) )
	local area_4 = area( ivec2( 26, 17 ), ivec2( 47, 31 ) )
	local idx = 1

	for t in self:coords( "marker" ) do
		self:set_cell( t, "floor" )
		local facing = generator.floor_facing( self, t, floor_id )
		self:place_entity( "terminal_base", t, facing )
		local e = self:place_entity( "terminal", t, facing )

		if idx == 1 then
			e:attach( "terminal_unlock", { data = { area = area_1, }, text = { entry = self.text.open, } } )
		elseif idx == 2 then
			e:attach( "terminal_unlock", { data = { area = area_2, }, text = { entry = self.text.open, } } )
		elseif idx == 3 then
			e:attach( "terminal_unlock", { data = { area = area_3, }, text = { entry = self.text.open, } } )
		elseif idx == 4 then
			e:attach( "terminal_unlock", { data = { area = area_4, }, text = { entry = self.text.open, } } )
		end
		idx = idx + 1
	end

	generator.handle_doors( self, self:get_area(), "marker2", "locked", { block = true, style = 1 } )

	-- Place floor on hound position markers
	-- 8 basic hounds:
	local cnt = 0 
	local ridx = math.random(8)
	for t in self:coords( "marker3" ) do
		self:set_cell( t, "floor" )
		self:set_cell_style( t, 1, true )
		cnt = cnt + 1
		if cnt == ridx then 
			self:add_entity( "rexio", t )
		else
			self:add_entity( "kerberos", t )
		end
	end

	-- Add difficulty-dependent additional hounds
	local add_hound_count = DIFFICULTY * 2
	local enemy_table = weight_list {
			{ 1, "cryoberos" },
			{ 1, "toxiberos" },
			{ 1, "cyberos" },		
		}

	for t in self:coords( "marker4" ) do
		self:set_cell( t, "floor" )
		self:set_cell_style( t, 1, true )

		if DIFFICULTY == 1 and add_hound_count > 0 then
			self:add_entity( enemy_table(), t )
			add_hound_count = add_hound_count - 1
		elseif DIFFICULTY == 2 and add_hound_count > 0 then
			self:add_entity( enemy_table(), t )
			add_hound_count = add_hound_count - 1
		elseif DIFFICULTY == 3 and add_hound_count > 0 then
			self:add_entity( enemy_table(), t )
			add_hound_count = add_hound_count - 1
		end
	end

	local rewards = {
		{ "adv_armor_red", "adv_armor_blue", "adv_assault_rifle", "adv_hunter_rifle", tier = 3, },
		{ "adv_headset", "adv_helmet_red", "adv_cvisor", tier = 3, },
		{ "powerup_backpack_completionist", },
		{},
	}
	local mug = generator.most_used_group()
	local greward = {
		melee      = { "adv_amp_melee", tier = 3, },
		explosives = { "adv_amp_general", tier = 3, },
		pistols    = { "adv_amp_pistol", tier = 3, },
		smgs       = { "adv_amp_pistol", tier = 3, },
		shotguns   = { "adv_amp_shotgun", tier = 3, },
		auto       = { "adv_amp_auto", tier = 3, },
		semi       = { "adv_amp_auto", tier = 3, },
		rotary     = { "adv_amp_auto", tier = 3, },
	}
	rewards[4] = greward[ mug ]
	rewards[2] = generator.episode_unique( self, "uni_shotgun_denial" ) or rewards[2]

	generator.drop_marker_rewards( self, "mark_special", self:get_area(), rewards )

	return result
end

register_blueprint "level_europa_pit_completionist"
{
	blueprint   = "level_base",
	text = {
		name = "The Pit",
		open = "WHO???",
	},
	environment = {
		music        = "music_beyond_01",
		lut          = "lut_07_yellowish",
		hdr_exposure = 1.8,
	},
	attributes = {
		returnable = true,
	},
	callbacks = {
		on_create = [[
     	    function ( self )
       	        generator.run( self, nil, europa_pit_completionist.generate, europa_pit.spawn )
            end
        ]],
		on_enter_level = [[
            function ( self, player, reenter )
                if reenter then return end
				world:special_visited( player, self )
			end
			]],
		on_cleared = [[
            function ( self )
                world:special_cleared( world:get_player(), self )
            end
        ]],		
	},
}
