local L = (...)

local score

score = {
	fields = {
		"endless_most_kills",
		"endless_most_time",
		"minute_most_kills",
		"minute_most_accuracy"
	},

	save = function(self)
		local values = {}

		for index, key in ipairs(self.fields) do
			table.insert(values, self[key])
		end

		local text = ("%s "):rep(#self.fields):format(
			unpack(values)
		)
		love.filesystem.write("score.txt", text)
	end,

	load = function(self)
		for index, key in ipairs(self.fields) do
			self[key] = 0
		end

		if (love.filesystem.isFile("score.txt")) then
			local data = love.filesystem.read("score.txt")
			local index = 1

			for entry in data:gmatch("%S+") do
				if (not tonumber(entry)) then
					break
				end

				self[self.fields[index]] = tonumber(entry)
				index = index + 1
			end
		end
	end,

	reset = function(self)
		for index, key in ipairs(self.fields) do
			self[key] = 0
		end

		self:save()
	end
}

return score