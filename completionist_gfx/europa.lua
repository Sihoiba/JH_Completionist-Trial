-- Copyright (c) ChaosForge Sp. z o.o.
nova.require "data/lua/gfx/common"

register_gfx_blueprint "powerup_backpack_completionist"
{
    uisprite = {
        icon = "data/texture/ui/icons/ui_kit_backpack",
        color = vec4( 0.6, 0.0, 0.6, 1.0 ),
    },
    light = {
        position    = vec3(0,0.1,0),
        color       = vec4(0.6,0.2,0.6,1),
    },
}