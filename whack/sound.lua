local L = (...)

local sound

local path_pattern = "asset/sound/%s.ogg"

sound = {
	volume = 1,
	fade_speed = 1,
	source_count = 1,
	sounds = {},
	fading = {},

	new = function(self)
		return self
	end,

	update = function(self, delta)
		for index, sound in ipairs(self.fading) do
			local vol = sound:getVolume() - (self.fade_speed * delta)
			if (vol <= 0) then
				sound:stop()
				sound:setVolume(self.volume)
				table.remove(self.fading, index)
			else
				sound:setVolume(vol)
			end
		end
	end,

	load_music = function(self, name, looping)
		local out = {}
		local path = path_pattern:format(name)

		self.sounds[name] = out

		if (love.filesystem.isFile(path)) then
			local source = love.audio.newSource(path, "stream")
			source:setLooping(looping)
			table.insert(out, source)
		else
			L:error("Could not load music '" .. tostring(name) .. "'")
		end
	end,

	load_effect = function(self, name)
		local out = {}
		local path = path_pattern:format(name)

		self.sounds[name] = out

		if (love.filesystem.isFile(path)) then
			for index = 1, self.source_count do
				table.insert(out, love.audio.newSource(path, "static"))
			end
		else
			L:error("Could not find sound '" .. tostring(name) .. "'")
		end
	end,

	play = function(self, name)
		if (self.sounds[name]) then
			for index, sound in ipairs(self.sounds[name]) do
				if (sound:isStopped()) then
					sound:setVolume(self.volume)
					sound:play()
					return
				end
			end

			L:notice("No source available for sound '" .. tostring(name) .. "' (perhaps source_count should be increased?)")
		else
			L:warn("Could not play sound '" .. tostring(name) .. "' (maybe it isn't loaded yet?)")
		end
	end,

	stop = function(self, name)
		if (self.sounds[name]) then
			for index, sound in ipairs(self.sounds[name]) do
				sound:stop()
			end
		else
			L:warn("Could not stop sound '" .. tostring(name) .. "' (maybe it isn't loaded yet?)")
		end
	end,

	fade = function(self, name)
		if (self.sounds[name]) then
			for index, sound in ipairs(self.sounds[name]) do
				table.insert(self.fading, sound)
			end
		end
	end
}

return sound