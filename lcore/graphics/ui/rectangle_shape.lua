local L, this = ...
this.title = "UI Rectangle Shape"
this.version = "1.0"
this.status = "production"
this.desc = "Provides facilities identifying a UI element as a rectangle. Does not provide rendering."

local oop = L:get("lcore.utility.oop")
local element = L:get("lcore.graphics.ui.element")
local rectangle_shape

rectangle_shape = oop:class(element)({
	w = 0,
	h = 0,

	_new = function(self, new, manager, x, y, w, h)
		new = element._new(self, new, manager, x, y)
		
		new.w = w or self.w
		new.h = h or self.w

		return new
	end,

	resize = function(self, w, h)
		self.w = w or self.w
		self.h = h or w or self.h

		if (self._resize) then
			self:_resize()
		end
	end,

	_resize = function(self)
	end,

	contains = function(self, x, y)
		local absx, absy = self.x + self.ox, self.y + self.oy
		return (x > absx and x < absx + self.w and y > absy and y < absy + self.h)
	end
})

return rectangle_shape