local L = require("lcore.core")
local L_love = L:get("lcore.platform.love.core")
local event = L:get("lcore.service.event")
local platform = L:get("lcore.platform.interface"):get()
platform:init()

L:get("whack.theme")
L:get("whack.assets")
local score = L:get("whack.scorekeeper")
score:load()
score:save()
local game = L:get("whack.game"):new()
event.global:hook(L_love.love_hooks, game)

love.graphics.setBackgroundColor(0, 0, 0)

game:set_state("main_menu", true)
game.states.fader.target = "title"
game.states.fader.state = 2
game.states.fader.alpha = 255

event.global:hook("quit", function()
	score:save()
end)