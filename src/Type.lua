--!strict
--[[
	Runtime type inspection helpers.
]]

local module = {}

--[[
	Returns Luau's runtime type name.
]]
module.Of = function(value: any): string
	return typeof(value)
end

--[[
	Checks a value against a Luau runtime type name.
]]
module.Is = function(value: any, name: string): boolean
	return typeof(value) == name
end

--[[
	Checks whether a value is a finite integer.
]]
module.IsInteger = function(value: any): boolean
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge and value % 1 == 0
end

--[[
	Checks whether a value is a finite number.
]]
module.IsNumber = function(value: any): boolean
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

--[[
	Checks whether a value is a callable function.
]]
module.IsCallable = function(value: any): boolean
	if type(value) == "function" then
		return true
	end

	if type(value) ~= "table" then
		return false
	end

	local metatable = getmetatable(value)
	return type(metatable) == "table" and type(metatable.__call) == "function"
end

--[[
	Checks whether a value is a table with only sequential numeric keys.
]]
module.IsArray = function(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	local count = 0

	for key in value do
		if type(key) ~= "number" or key % 1 ~= 0 or key < 1 then
			return false
		end

		count += 1
	end

	return count == #value
end

return table.freeze(module)
