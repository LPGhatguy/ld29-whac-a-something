local L, this = ...
this.title = "UI Circle Shape"
this.version = "1.0"
this.status = "production"
this.desc = "Provides methods identifying this UI element as a circle. Does not provide rendering."

local oop = L:get("lcore.utility.oop")
local element = L:get("lcore.graphics.ui.element")
local circle_shape

circle_shape = oop:class(element)({
	r = 0,

	_new = function(self, new, manager, x, y, r)
		new = element._new(self, new, manager, x, y)
		new.r = r or new.r

		return new
	end,

	resize = function(self, r)
		self.r = r or self.r

		if (self._resize) then
			self:_resize()
		end
	end,

	_resize = function(self)
	end,

	contains = function(self, x, y)
		return ((x - self.x) ^ 2 + (y - self.y) ^ 2) < (self.r ^ 2)
	end
})

return circle_shape