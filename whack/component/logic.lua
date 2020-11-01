local L = (...)
local oop = L:get("lcore.utility.oop")
local event = L:get("lcore.service.event")
local whackable = L:get("whack.whackable")
local sound = L:get("whack.sound")
local font = L:get("lcore.graphics.font")
local textbutton = oop:mix(
	"lcore.graphics.ui.textlabel",
	"lcore.graphics.ui.button"
)

local DEBUG_FORCE_WHACKABLE-- = "shoe.lua"
local logic

logic = oop:class(event)({
	game_mode = "game_unknown",
	finished = false,
	debug_draw = false,

	mouse_x = 0,
	mouse_y = 0,

	whackables = {},
	whackable_base_scale = 0.3,
	whackable_dist_scale = 1.5,

	hammer_image = nil,
	hammer_to_sound = false,
	hammer_dist_scale = 0.7,
	hammer_base_scale = 0.3,
	hammer_mouse_offset = {715, 380},
	hammer_swing_offset = {100, 180},
	hammer_rotation = 0,
	hammer_start_angle = -math.pi / 5,
	hammer_swinging = false,
	hammer_swing_for = 0.04,
	hammer_swing_back = 0.12,
	hammer_swing_elapsed = 0,

	board_image = nil,
	board_seams = {470, 504, 654, 858, 951, 1080},
	board_quad_count = 4,
	board_quads = {},

	max_spawns = 1,
	spawn_lifetime = 3,
	time = 0,
	misses = 0,
	kills = 0,
	swings = 0,
	got_away = 0,

	holes = {
		{{481, 515}, {1440, 515}},
		{{960, 545}},
		{{555, 710}, {1360, 710}},
		{{960, 925}},
		{{320, 1015}, {1600, 1015}}
	},

	_new = function(self, new, whack)
		new.whack = whack

		new.hammer_image = love.graphics.newImage("asset/image/hammer-1.png")
		new.board_image = love.graphics.newImage("asset/image/board-2.png")

		new:load_whackables("asset/whackables")

		new:resize()

		return new
	end,

	resize = function(self)
		self:destroy()

		local bw, bh = self.board_image:getDimensions()
		local sw, sh = love.window.getDimensions()
		local ratio = math.min(sw / bw, sh / bh)
		local pbw, pbh = bw * ratio, bh * ratio

		local last_seam = 0
		self.board_quads = {}

		for index, seam in ipairs(self.board_seams) do
			local next_seam = self.board_seams[index + 1] or bh

			table.insert(self.board_quads, {
				love.graphics.newQuad(0, last_seam, bw, seam - last_seam, bw, bh),
				(sw - pbw) / 2, last_seam * ratio, 0, ratio
			})

			last_seam = seam
		end

		self.pause_button = textbutton:new(self, "Pause!", pbw - 170, 20, 150, 50)
		self.pause_button.click = function()
			self.hammer_swinging = false
			self.whack:set_state("game_paused", true)
		end

		for index, set in ipairs(self.holes) do
			for key, hole in ipairs(set) do
				if (hole.member) then
					hole.member.leaving = true
				end
			end
		end
	end,

	init = function(self)
		self.max_spawns = 1
		self.spawn_lifetime = 3

		self.finished = false

		self.time = 0
		self.kills = 0
		self.misses = 0
		self.swings = 0
		self.got_away = 0

		for index, set in ipairs(self.holes) do
			for key, hole in ipairs(set) do
				hole.member = nil
			end
		end
	end,

	state_changed = function(self, from)
		if (not from.logic) then
			print("RESET!")
			self:init()
		end

		love.mouse.setCursor(love.mouse.getSystemCursor("crosshair"))
	end,

	state_changing = function(self, to)
		if (not to.logic) then
			love.mouse.setCursor(love.mouse.getSystemCursor("arrow"))
		end
	end,

	quit = function(self)
		self.whack.states[self.game_mode]:finish()
		self.paused = false
		self.whack:set_state("main_menu")
	end,

	swing = function(self, x, y)
		self.hammer_to_sound = true
		self.swings = self.swings + 1

		for index = #self.holes, 1, -1 do
			local set = self.holes[index]
			for key, hole in ipairs(set) do
				if (hole.member) then
					if (hole.member:contains(x, y) and hole.member.alive) then
						self.kills = self.kills + 1
						hole.member:die()
						return
					end
				end
			end
		end

		self.misses = self.misses + 1
	end,

	load_whackables = function(self, path)
		if (love.filesystem.isDirectory(path)) then
			for index, file in ipairs(love.filesystem.getDirectoryItems(path)) do
				local full = path .. "/" .. file

				if (love.filesystem.isFile(full)) then
					if (DEBUG_FORCE_WHACKABLE) then
						if (file == DEBUG_FORCE_WHACKABLE) then
							table.insert(self.whackables, whackable:new():load(full))
						end
					else
						table.insert(self.whackables, whackable:new():load(full))
					end
				end
			end
		else
			L:error("Couldn't load whackables from '" .. tostring(path) .. "'")
		end
	end,

	spawn_whackable = function(self)
		for i = 1, love.math.random(1, self.max_spawns) do
			local usable = {}

			for index, set in ipairs(self.holes) do
				for key, hole in ipairs(set) do
					if (not hole.member) then
						table.insert(usable, hole)
					end
				end
			end

			if (#usable < 1) then
				print("No holes available, skipping spawn.")
				return
			end

			local bw, bh = self.board_image:getDimensions()
			local sw, sh = love.window.getDimensions()
			local ratio = math.min(sw / bw, sh / bh)
			local pbw, pbh = bw * ratio, bh * ratio

			local target = usable[love.math.random(1, #usable)]

			local whackable = self.whackables[love.math.random(1, #self.whackables)]

			target.member = whackable:new(target[1] * ratio + (sw - pbw) / 2, target[2] * ratio + whackable.bottom)
			target.member.fy = target.member.y
			target.member.ty = target[2] * ratio + whackable.top * target.member.s
			target.member.scale = self.whackable_base_scale + ratio * (self.whackable_dist_scale * target.member.ty / sh)
			target.member.ty = target.member.ty + whackable.top * target.member.scale
			target.member.dies_at = self.time + self.spawn_lifetime
		end
	end,

	finish = function(self)
		self.finished = true

		for index, set in ipairs(self.holes) do
			for key, hole in ipairs(set) do
				if (hole.member) then
					if (hole.member.alive) then
						self.got_away = self.got_away + 1
					end
				end
			end
		end
	end,

	update = function(self, delta)
		if (not self.whack.paused and not self.finished) then
			self.time = self.time + delta
			self.mouse_x, self.mouse_y = love.mouse.getPosition()

			for index, set in ipairs(self.holes) do
				for key, hole in ipairs(set) do
					if (hole.member) then
						hole.member:update(delta)

						if (self.time >= hole.member.dies_at and not hole.member.leaving) then
							hole.member.leaving = true
						elseif (hole.member.gone) then
							if (hole.member.alive) then
								self.got_away = self.got_away + 1
							end

							hole.member = nil
						end
					end
				end
			end

			local for_speed = -self.hammer_start_angle / self.hammer_swing_for
			local back_speed = -self.hammer_start_angle / (self.hammer_swing_back - self.hammer_swing_for)

			if (self.hammer_swinging) then
				self.hammer_swing_elapsed = self.hammer_swing_elapsed + delta

				if (self.hammer_swing_elapsed < self.hammer_swing_for) then
					self.hammer_rotation = self.hammer_swing_elapsed * for_speed
				else
					if (self.hammer_to_sound) then
						sound:play("hammer-hit")
						self.hammer_to_sound = false
					end

					if (self.hammer_swing_elapsed < self.hammer_swing_back) then
						self.hammer_rotation = for_speed * self.hammer_swing_for - (self.hammer_swing_elapsed - self.hammer_swing_for) * back_speed
					else
						self.hammer_swinging = false
						self.hammer_rotation = 0
					end
				end
			end

			self:fire("update", delta)
		end
	end,

	draw = function(self)
		local bw, bh = self.board_image:getDimensions()
		local sw, sh = love.window.getDimensions()
		local ratio = math.min(sw / bw, sh / bh)
		local pbw, pbh = bw * ratio, bh * ratio

		if (self.whack.paused) then
			if (self.whack.states[self.game_mode]) then
				self.whack.states[self.game_mode]:draw()
			else
				print("ERROR ERROR LINE logic.lua")
			end
		end

		for index, quad in ipairs(self.board_quads) do
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(self.board_image, unpack(quad))

			if (self.debug_draw) then
				love.graphics.setColor(255 * (index / #self.board_quads), 0, 0)
				local x, y, w, h = quad[1]:getViewport()
				love.graphics.line(quad[2], quad[3], quad[2] + w, quad[3])
			end

			if (self.holes[index]) then
				for key, hole in ipairs(self.holes[index]) do
					if (hole.member) then
						hole.member:draw()
					end
				end
			end
		end

		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, pbh, sw, sh - pbh)

		self:fire("draw")

		local mx, my = self.mouse_x, self.mouse_y
		local hammer_scale = self.hammer_base_scale + ratio * my * (self.hammer_dist_scale / sh)
		local hsx = self.hammer_swing_offset[1]
		local hsy = self.hammer_swing_offset[2]
		local hx = mx - (self.hammer_mouse_offset[1]) * hammer_scale + hsx * hammer_scale
		local hy = my - (self.hammer_mouse_offset[2]) * hammer_scale + hsy * hammer_scale

		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.hammer_image,
			hx, hy, self.hammer_rotation + self.hammer_start_angle,
			hammer_scale, nil,
			hsx, hsy
		)

		if (self.debug_draw) then
			love.graphics.rectangle("line", hx, hy, mx - hx, my - hy)

			love.graphics.setPointSize(4)
			for index, set in ipairs(self.holes) do
				for key, hole in ipairs(set) do
					love.graphics.point(hole[1] * ratio, hole[2] * ratio)
				end
			end
		end
	end,

	keypressed = function(self, key)
		if (key == "escape") then
			if (self.whack.paused) then
				self.whack:set_state("game")
			else
				self.whack:set_state("game_paused")
			end
		end
	end,

	mousepressed = function(self, x, y, button)
		if (not self.whack.paused) then
			if (button == "l" or button == "r") then
				if (not self.hammer_swinging) then
					self.hammer_swinging = true
					self.hammer_swing_elapsed = 0
					self:swing(x, y)
				end
			end

			self:fire("mousepressed", x, y, button)
		end
	end
})

return logic