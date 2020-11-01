local L = (...)
local oop = L:get("lcore.utility.oop")
local event = L:get("lcore.service.event")
local font = L:get("lcore.graphics.font")
local textbutton = oop:mix(
	"lcore.graphics.ui.textlabel",
	"lcore.graphics.ui.button"
)

local main_menu

main_menu = oop:class(event)({
	_new = function(self, new, whack)
		new.whack = whack

		new.background_image = love.graphics.newImage("asset/image/background.png")

		new:resize()

		return new
	end,

	resize = function(self)
		self:destroy()

		local sw, sh = love.window.getDimensions()
		local rw, rh = 1920, 1080
		local ratio = math.min(sw / rw, sh / rh)
		local ystart = 320 * ratio
		local xstart = (sw - rw * ratio) / 2

		self.endless = textbutton:new(self, "Endless Mode!", xstart + 510 * ratio, ystart, 900 * ratio, 120 * ratio)
		self.endless.click = function(...)
			self.whack.states.pause_menu.game_mode = "game_endless"
			self.whack.states.logic.game_mode = "mode_endless"
			self.whack:set_state("game_endless")
		end

		self.minute_button = textbutton:new(self, "Minute Mode!", xstart + 510 * ratio, ystart + 160 * ratio, 900 * ratio, 120 * ratio)
		self.minute_button.click = function(...)
			self.whack.states.pause_menu.game_mode = "game_minute"
			self.whack.states.logic.game_mode = "mode_minute"
			self.whack:set_state("game_minute")
		end

		self.acc_button = textbutton:new(self, "Accomplishments!", xstart + 435 * ratio, ystart + 160 * ratio * 2, 1050 * ratio, 120 * ratio)
		self.acc_button.click = function(...)
			self.whack:set_state("accomplishments")
		end

		self.quit_button = textbutton:new(self, "Quit", xstart + 510 * ratio, ystart + 160 * ratio * 3, 900 * ratio, 120 * ratio)
		self.quit_button.click = function(...)
			love.event.push("quit")
		end
	end,

	draw = function(self)
		local sw, sh = love.window.getDimensions()
		local rw, rh = 1920, 1080
		local ratio = math.min(sw / rw, sh / rh)

		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.background_image, (sw - rw * ratio) / 2, 0, 0, ratio)

		love.graphics.setFont(font:get(math.floor(150 * ratio)))
		love.graphics.printf("WHAC-A-SOMETHING!", 0, 40, love.window.getWidth(), "center")

		love.graphics.setFont(font:get(math.floor(40 * ratio)))
		love.graphics.printf("Made by LPGhatguy and Cassassin for Ludum Dare #29", 0, 180, love.window.getWidth(), "center")

		love.graphics.printf("Press F11 to fullscreen", 0, 0, love.window.getWidth() - 8, "right")

		self:fire("draw")
	end
})

return main_menu