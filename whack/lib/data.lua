local L = (...)

local data

data = {
	read = function(self, file)
		if (love.filesystem.isFile(file)) then
			return love.filesystem.load(file)()
		else
			return nil, L:error("Could not read from file '" .. tostring(file) .. "'")
		end
	end
}

return data