local L, this = ...
this.title = "UI Element"
this.version = "1.1"
this.status = "production"
this.desc = "The root element of all UI elements in LCORE"

local oop = L:get("lcore.utility.oop")
local gcore = L:get("lcore.graphics.core")
local event = L:get("lcore.service.event")
local element

element = oop:class()({
	manager = nil,
	x = 0,
	y = 0,
	z = 0,
	ox = 0,
	oy = 0,

	_new = function(self, new, manager, x, y)
		new.manager = manager or new.manager
		new.x = x or new.x
		new.y = y or new.y

		new:connect(manager)

		return new
	end,

	_destroy = function(self)
		self:connect()
	end,

	_connect = function(self, manager)
		manager:hook("draw", self)
	end,

	connect = function(self, manager)
		if (self.manager) then
			self.manager:unhook_object(self)
		end

		self.manager = manager

		if (manager) then
			self.manager = manager
			self:_connect(manager)
		end
	end,

	draw = function(self)
		self.ox = gcore.x
		self.oy = gcore.y
	end,

	contains = function(self, x, y)
		return true
	end
})

return element