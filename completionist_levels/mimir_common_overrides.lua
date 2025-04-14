-- Copyright (c) ChaosForge Sp. z o.o.
nova.require "data/lua/core/common"
nova.require "data/lua/jh/data/common"
nova.require "data/lua/jh/data/entities/sentry_bot"

register_blueprint "mimir_sentry_bot_completionist"
{
    blueprint = "sentry_bot_base",
    lists = {
        group = "being",
    },
    text = {
        name      = "MDF sentry",
        namep     = "MDF sentries",
        entry     = "MDF Sentry",
    },
    ascii     = {
        glyph     = "S",
        color     = MAGENTA,
    },
    callbacks = {
        on_create = [=[
        function( self )
            self:attach( "sentry_bot_2_chaingun" )
            self:attach( "ammo_762", { stack = { amount = 15 + math.random(5) } } )
            self:attach( "mimir_terminal_download" )
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
                ui:spawn_fx( nil, "fx_drone_die", nil, world:get_position( self ) )
                if self.attributes.mdf then
                    local player  = world:get_player()
                    local runtime = player:child("mimir_shutdown_runtime_completionist")
                    if runtime and runtime.attributes.counter > 0 then
                        runtime.attributes.counter = runtime.attributes.counter - 1
                    end
                end
            end
        ]=],
    },
    attributes = {
        speed            = 1.0,
        experience_value = 60,
        health           = 60,
        smoke_charge     = 1,
        repair_charge    = 4,
        repair_amount    = 10,
        mdf              = 0,
        resist = {
            emp = 25,
        },
    },
    preload = "sentry_bot_2_chaingun",
}
