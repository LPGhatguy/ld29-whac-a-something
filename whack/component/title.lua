local L = (...)
local oop = L:get("lcore.utility.oop")
local color = L:get("lcore.graphics.color")
local font = L:get("lcore.graphics.font")

local title

title = oop:class()({
	time = 0,

	_new = function(self, new, whack)
		new.whack = whack

		new.title_text = love.graphics.newImage("asset/image/title-text.png")
		new.title_wheel = love.graphics.newImage("asset/image/title-wheel.png")

		return new
	end,

	update = function(self, delta)
		self.time = self.time + delta
	end,

	draw = function(self)
		local rw, rh = 1920, 1080
		local sw, sh = love.window.getDimensions()
		local ratio = math.min(sw / rw, sh / rh)

		local tww, twh = self.title_wheel:getDimensions()

		love.graphics.setColor(50, 0, 50)
		love.graphics.rectangle("fill", 0, 0, sw, sh)

		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.title_wheel, 960 * ratio, 800 * ratio, self.time, ratio * 1.5, nil, 305, 308)

		love.graphics.setColor(color:hsv((self.time * 45) % 360, 100, 100, 255))
		love.graphics.draw(self.title_text, 0, 0, 0, ratio)
	end,

	keypressed = function(self, key)
		self.whack:set_state("main_menu")
	end,

	mousepressed = function(self, x, y, button)
		self.whack:set_state("main_menu")
	end
})

return title