register_gfx_blueprint "wither_watcher"
{
    animator = "animator_watcher",
    skeleton = "data/model/beholder_01.nmd",
    gibs     = {
        blueprint = "gibs_watcher",
        always = true,
        skip_offset = true,
    },
    {
		scene = {
			orientation = vec4(0.0,0.707,-0.707,0.0),
		},
        {
            render = {
                mesh        = "data/model/beholder_01.nmd:beholder_01",
                material    = "trial_gfx/textures/beholder_01/beholder_01",
            },
        },
        {
            render = {
                mesh        = "data/model/beholder_01.nmd:beholder_01_eye_01",
                material    = "trial_gfx/textures/beholder_01/beholder_01_eye_01",
            },
        },
    },
    movement = {
        floating = 0.6,
    },
}