local L = (...)
local oop = L:get("lcore.utility.oop")
local font = L:get("lcore.graphics.font")
local sound = L:get("whack.sound")
local textbutton = oop:mix(
	"lcore.graphics.ui.textlabel",
	"lcore.graphics.ui.button"
)

local endless

endless = oop:class("lcore.service.event")({
	_new = function(self, new, whack)
		new.whack = whack

		new.return_button = textbutton:new(new, "Main Menu", 8, 8, 300, 50)
		new.return_button.click = function(self)
			new.whack:set_state("main_menu")
		end

		return new
	end,

	state_changed = function(self, from)
		sound:play("music-results")
	end,

	state_changing = function(self, to)
		sound:fade("music-results")
	end,

	draw = function(self)
		local logic = self.whack.states.logic
		local game = self.whack.states.mode_endless

		local sw, sh = love.window.getDimensions()
		local tx, ty = 40, 120
		local tw, th = sw - 80, sh - 120

		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font:get(40))
		love.graphics.printf("Endless Mode Results", 0, 60, sw, "center")

		local lasted = game.time
		local lasted_seconds = math.floor(lasted % 60)
		local lasted_minutes = math.floor(lasted / 60)

		local assessment = 
			(lasted < 30) and "Ouch!" or
			(lasted < 60) and "Try minute mode!" or
			(lasted < 60*2) and "A minute and some!" or
			(lasted < 60*3) and "TWO MINUTES!?" or
			(lasted < 60*5) and "That's some time!" or
			(lasted < 60*10) and "Great work!" or
			(lasted < 60*15) and "got life?" or
			(lasted < 60*20) and "Who spends so long playing Whac-A-Mole?" or
			"I guess, you, uh, win."

		love.graphics.setFont(font:get(math.floor(th / 10)))
		love.graphics.printf(([[
			Kills: %d

			Swings: %d
			Misses: %d

			You lasted for %d minutes, %d seconds!
			%s
		]]):format(
			logic.kills,
			logic.swings,
			logic.misses,
			lasted_minutes,
			lasted_seconds,
			assessment
		), tx, ty, tw, "center")

		self:fire("draw")
	end
})

return endless