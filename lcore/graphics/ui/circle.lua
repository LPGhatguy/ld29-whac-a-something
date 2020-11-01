local L, this = ...
this.title = "Circle"
this.version = "1.0"
this.status = "production"
this.desc = "A UI circle element with a border."

local oop = L:get("lcore.utility.oop")
local color = L:get("lcore.graphics.color")
local circle_shape = L:get("lcore.graphics.ui.circle_shape")
local circle

circle = oop:class(circle_shape)({
	background_color = color:get("darkgray"),
	border_color = color:get("silver"),
	border_width = 2,

	draw = function(self)
		circle_shape.draw(self)

		local bw = self.border_width
		local hw = bw / 2
		love.graphics.setLineWidth(bw)
		love.graphics.setColor(self.border_color)
		love.graphics.circle("line", self.x, self.y, self.r + bw)

		love.graphics.setColor(self.background_color)
		love.graphics.circle("fill", self.x, self.y, self.r)
	end
})

return circle