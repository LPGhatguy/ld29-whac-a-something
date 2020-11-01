local L, this = ...
this.title = "Font Core"
this.version = "1.0"
this.status = "production"
this.desc = "Provides an efficient interface into using multiple font faces and sizes."
this.todo = {
	"Work into lcore.service.content's featureset."
}

local font

font = {
	imagefonts = {},
	default_face = nil,
	default_scaling = {"linear", "linear"},
	loaded = {},

	register_imagefont = function(self, name, path, glyphstring)
		self.imagefonts[name] = {path, glyphstring}
	end,

	getn = function(self, name)
		return self:get(16, name)
	end,

	get = function(self, size, name)
		name = name or self.default_face
		local rname = name or "default"
		local lfont

		if (self.loaded[rname]) then
			if (self.loaded[rname][size]) then
				lfont = self.loaded[rname][size]
			end
		else
			self.loaded[rname] = {}
		end

		if (not lfont) then
			if (name) then
				if (self.imagefonts[name]) then
					lfont = love.graphics.newImageFont(unpack(self.imagefonts[name]))
				else
					lfont = love.graphics.newFont(name, size)
				end
			else
				lfont = love.graphics.newFont(size)
			end

			lfont:setFilter(unpack(self.default_scaling))
			self.loaded[rname][size] = lfont
		end

		return lfont
	end
}

return font