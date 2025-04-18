-- Copyright (c) ChaosForge Sp. z o.o.
nova.require "data/lua/gfx/common"
nova.require "data/lua/jh/gfx/entities/sentry_bot"

register_gfx_blueprint "mimir_sentry_bot_completionist"
{
    ragdoll = "ragdoll_sentry_bot",
    animator = "animator_sentry_bot",
    skeleton = "data/model/sentry_bot_01.nmd",
    rotation = {
        pivot = "RigBody",
        range = 3.14,
        keep  = true,
    },
    scale = { scale = 1.2, },
    render = {
        mesh        = "data/model/sentry_bot_01.nmd:sentry_bot_body_01",
        material    = "data/texture/sentry_bot_01/C/sentry_bot_body_01",
    },
    {
        scale = { scale = 1.2, },
        render = {
            mesh        = "data/model/sentry_bot_01.nmd:sentry_bot_legs_01",
            material    = "data/texture/sentry_bot_01/C/sentry_bot_legs_01",
        },
    },
}
