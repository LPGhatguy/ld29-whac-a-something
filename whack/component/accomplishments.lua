local L = (...)
local oop = L:get("lcore.utility.oop")
local font = L:get("lcore.graphics.font")
local score = L:get("whack.scorekeeper")
local textbutton = oop:mix(
	"lcore.graphics.ui.textlabel",
	"lcore.graphics.ui.button"
)

local accomplish

accomplish = oop:class("lcore.service.event")({
	_new = function(self, new, whack)
		new.whack = whack

		new:resize()

		return new
	end,

	resize = function(self)
		self:destroy()

		local rw, rh = 1920, 1080
		local sw, sh = love.window.getDimensions()
		local ratio = math.min(sw / rw, sh / rh)

		self.back_button = textbutton:new(self, "Main Menu", 8, 8, 300, 50)
		self.back_button.click = function()
			self.whack:set_state("main_menu")
		end

		self.reset_button = textbutton:new(self, "Reset", 8, sh - 58, 300, 50)
		self.reset_button.click = function()
			score:reset()
		end
	end,

	draw = function(self)
		love.graphics.setColor(255, 255, 255)

		local rw, rh = 1920, 1080
		local sw, sh = love.window.getDimensions()
		local ratio = math.min(sw / rw, sh / rh)

		love.graphics.setFont(font:get(120 * ratio))
		love.graphics.printf("ACCOMPLISHMENTS!", 0, 70, sw, "center")

		love.graphics.setFont(font:get(80 * ratio))
		love.graphics.printf(([[
			ENDLESS MODE
			Most Hits: %d
			Longest Survived: %d minutes, %d seconds

			MINUTE MODE
			Most Hits: %d
			Highest Accuracy: %d%%
		]]):format(
			score.endless_most_kills,
			math.floor(score.endless_most_time / 60),
			math.floor(score.endless_most_time % 60),

			score.minute_most_kills,
			score.minute_most_accuracy
		), 0, 200, sw, "center")

		self:fire("draw")
	end
})

return accomplish