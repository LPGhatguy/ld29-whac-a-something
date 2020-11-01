local L, this = ...
this.title = "Table Extension Library"
this.version = "1.0"
this.status = "production"
this.desc = "Provides extensions for operating on tables."

local utable
local test

utable = {
	--[[
	@method equal
	#title Equality
	#def (table first, table second, [boolean no_reverse])
	#returns boolean result, [mixed error_key]
	#desc Checks if each value of tables first and second are equal.
	#desc If result is false, error_key contains the first key where a mismatch occured.
	#desc If no_reverse is true, only first is iterated through. This is used internally.
	]]
	equal = function(self, first, second, no_reverse)
		for key, value in pairs(first) do
			if (second[key] ~= value) then
				return false, key
			end
		end

		if (not no_reverse) then
			return utable:equal(second, first, true)
		else
			return true
		end
	end,

	--[[
	@method congruent
	#title Congruency
	#def (table first, table second, [boolean no_reverse])
	#returns boolean result, [mixed error_key]
	#desc Checks if first and second are equal recursively. Tables are iterated through.
	#desc If result is false, error_key contains the first key where a mismatch occured.
	#desc If no_reverse is true, only first is iterated through. This is used internally.
	]]
	congruent = function(self, first, second, no_reverse)
		for key, value in pairs(first) do
			local value2 = second[key]

			if (type(value) == type(value2)) then
				if (type(value) == "table") then
					if (not utable:congruent(value, value2)) then
						return false, key
					end
				else
					if (value ~= value2) then
						return false, key
					end
				end
			else
				return false, key
			end
		end

		if (not no_reverse) then
			return utable:congruent(second, first, true)
		else
			return true
		end
	end,

	--[[
	@method copylock
	#title Copylock
	#def (table target)
	#returns table target
	#desc Sets a flag in the table that forces copying and merging functions to not copy this table.
	]]
	copylock = function(self, target)
		target.__nocopy = true

		return target
	end,

	--[[
	@method copy
	#title Shallow Copy
	#def (table source, [table target])
	#returns table target
	#desc Performs a shallow copy from source to target.
	#desc If target is not specified, a new table is created. The location copied to is returned.
	]]
	copy = function(self, source, target)
		target = target or {}

		for key, value in pairs(source) do
			target[key] = value
		end

		return target
	end,

	--[[
	@method deepcopy
	#title Deep Copy
	#def (table source, [table target, boolean break_lock])
	#returns table target
	#desc Performs a deep copy from source to target.
	#desc If a target is not specified, a new table is created. The location copied to is returned.
	#desc If break_lock is true, any copylocked tables are copied anyway.
	]]
	deepcopy = function(self, source, target, break_lock)
		target = target or {}

		for key, value in pairs(source) do
			if (type(value) == "table") then
				if (value.__nocopy and not break_lock) then
					target[key] = value
				else
					target[key] = utable:deepcopy(value)
				end
			else
				target[key] = value
			end
		end

		return target
	end,

	--[[
	@method merge
	#title Shallow Merge
	#def (table source, table target)
	#returns table target
	#desc Performs a shallow merge from source to target.
	#desc Values from source are copied into target unless they already exist.
	]]
	merge = function(self, source, target)
		if (not target) then
			return nil
		end

		for key, value in pairs(source) do
			if (not target[key]) then
				target[key] = value
			end
		end

		return target
	end,

	--[[
	@method copymerge
	#title Shallow Copy-Merge
	#def (table source, table target)
	#returns table target
	#desc Performs a shallow merge from source to target.
	#desc Values from source are copied into target unless they already exist.
	#desc Table values are copied unless they are copylocked.
	#desc If break_lock is true, any copylocked tables are copied anyway.
	]]
	copymerge = function(self, source, target, break_lock)
		if (not target) then
			return nil
		end

		for key, value in pairs(source) do
			if (not target[key]) then
				if (type(value) == "table") then
					if (not value.__nocopy and not break_lock) then
						target[key] = utable:copy(value)
					else
						target[key] = value
					end
				else
					target[key] = value
				end
			end
		end

		return target
	end,

	--[[
	@method invert
	#title Invert
	#def (table source, [table target])
	#returns table target
	#desc Inverts the table source into target. All keys become values and vice versa.
	#desc Behavior with duplicate values is undefined.
	#desc If not target is not defined, a new table will be created.
	]]
	invert = function(self, source, target)
		target = target or {}

		for key, value in pairs(source) do
			target[value] = key
		end

		return target
	end,

	--[[
	@method contains
	#title Contains Value
	#def (table source, mixed value)
	#return boolean result
	#desc Returns whether the desired value exists in the table
	]]
	contains = function(self, source, value)
		for key, compare in pairs(source) do
			if (compare == value) then
				return true
			end
		end

		return false
	end
}

return utable