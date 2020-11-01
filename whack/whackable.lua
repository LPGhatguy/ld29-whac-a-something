local L = (...)
local oop = L:get("lcore.utility.oop")
local utable = L:get("lcore.utility.table")
local data = L:get("whack.lib.data")
local sound = L:get("whack.sound")

local whackable

whackable = oop:class()({
	alive_images = {},
	dead_image = nil,
	dead_sound = nil,
	alive_frame = 1,
	frame_speed = 0.6,
	frame_time = 0,
	alive = true,
	scale = 1,
	bottom = 300,
	top = 0,
	up_speed = 1600,
	down_speed = 1200,
	bleeds = true,
	leaving = false,
	gone = false,
	min_waffle_speed = 0,
	max_waffle_speed = 0,
	absolute_waffle = false,
	waffle_speed = 0,
	waffle_amount = math.pi / 4,
	waffle_direction = 1,
	dies_at = 0,
	start_falling_at = 0,
	fall_delay = 0.5,
	t = 0,
	x = 0,
	y = 0,
	s = 1,
	ty = 0,
	fy = 0,
	r = 0,

	_new = function(self, new, x, y)
		new.x = x or new.x
		new.y = y or new.y

		new.frame_speed = love.math.random(70, 100) / 100

		if (not new.absolute_waffle) then
			new.waffle_speed = love.math.random(new.min_waffle_speed * 100, new.max_waffle_speed * 100) / 100
		end

		return new
	end,

	load = function(self, filename)
		local source = data:read(filename)

		utable:copy(source, self)

		if (type(self.dead_image) == "string") then
			self.dead_image = love.graphics.newImage(self.dead_image)
		end

		for key, value in ipairs(self.alive_images) do
			if (type(value) == "string") then
				self.alive_images[key] = love.graphics.newImage(value)
			end
		end

		if (self.dead_sound) then
			sound:load_effect(self.dead_sound)
		end

		return self
	end,

	update = function(self, delta)
		self.t = self.t + delta

		self.frame_time = self.frame_time + delta

		if (self.frame_time >= self.frame_speed) then
			self.alive_frame = self.alive_frame + 1
			self.frame_time = self.frame_time - self.frame_speed

			if (self.alive_frame > #self.alive_images) then
				self.alive_frame = 1
			end
		end

		if (self.leaving) then
			if (self.t >= self.start_falling_at) then
				if (self.y == self.fy) then
					self.gone = true
				else
					self.y = math.min(self.y + self.down_speed * delta, self.fy)
				end
			end
		else
			if (self.y ~= self.ty) then
				self.y = math.max(self.y - self.up_speed * delta, self.ty)
			end
		end

		if (math.abs(self.r) > self.waffle_amount) then
			self.r = self.waffle_amount * self.waffle_direction
			self.waffle_direction = -self.waffle_direction
		end

		if (self.alive) then
			self.r = self.r + self.waffle_amount * self.waffle_direction * self.waffle_speed * delta
		end
	end,

	die = function(self)
		self.alive = false
		self.leaving = true
		self.start_falling_at = self.t + self.fall_delay

		if (self.dead_sound) then
			sound:play(self.dead_sound)
		end
	end,

	contains = function(self, x, y)
		local image = self:get_image()
		local w, h = image:getDimensions()
		w = w * self.s * self.scale
		h = h * self.s * self.scale

		return (x > self.x - w / 2 and x < self.x + w / 2 and
			y > self.y - h and y < self.y)
	end,

	get_image = function(self)
		if (self.alive) then
			return self.alive_images[self.alive_frame]
		else
			return self.dead_image
		end
	end,

	draw = function(self)
		local image = self:get_image()

		if (image) then
			local w, h = image:getDimensions()
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(image,
				self.x, self.y,
				self.r,
				self.s * self.scale, nil,
				w / 2, h
			)
		else
			love.graphics.rectangle("fill", self.x, self.y, 50, 50, 25, 25)
		end
	end
})

return whackable