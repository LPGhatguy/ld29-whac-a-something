local L = (...)
local oop = L:get("lcore.utility.oop")
local font = L:get("lcore.graphics.font")
local sound = L:get("whack.sound")
local textbutton = oop:mix(
	"lcore.graphics.ui.textlabel",
	"lcore.graphics.ui.button"
)

local minute

minute = oop:class("lcore.service.event")({
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
		local game = self.whack.states.mode_minute

		local sw, sh = love.window.getDimensions()
		local tx, ty = 40, 120
		local tw, th = sw - 80, sh - 120

		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font:get(40))
		love.graphics.printf("Minute Mode Results", 0, 60, sw, "center")

		local swing_accuracy = math.floor(100 * logic.kills / logic.swings)
		if (swing_accuracy ~= swing_accuracy) then
			swing_accuracy = 0
		end

		local total_accuracy = math.floor(100 * logic.kills / (logic.swings + logic.got_away))
		if (total_accuracy ~= total_accuracy) then
			total_accuracy = 0
		end

		local assessment = 
			(total_accuracy < 10) and "Failure!" or
			(total_accuracy < 30) and "Try harder!" or
			(total_accuracy < 60) and "Good try!" or
			(total_accuracy < 80) and "Great job!" or
			(total_accuracy < 90) and "Nice!" or
			(total_accuracy < 100) and "So close!" or
			"Such Phenominal!"

		love.graphics.setFont(font:get(math.floor(th / 10)))
		love.graphics.printf(([[
			Kills: %d
			Got Away: %d
			Swings: %d
			Misses: %d

			Swing Accuracy: %d%%
			Total Accuracy: %d%%
			%s
		]]):format(
			logic.kills,
			logic.got_away,
			logic.swings,
			logic.misses,
			swing_accuracy,
			total_accuracy,
			assessment
		), tx, ty, tw, "center")

		self:fire("draw")
	end
})

return minute