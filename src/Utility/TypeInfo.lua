--!strict
--[[
	Runtime type and value inspection.
]]

local module = {}

module.Of = function(value: any): string
	return typeof(value)
end

module.Is = function(value: any, name: string): boolean
	return typeof(value) == name
end

module.IsInteger = function(value: any): boolean
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge and value % 1 == 0
end

module.IsNumber = function(value: any): boolean
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

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

module.IsEmpty = function(value: any): boolean
	if type(value) == "string" then
		return #value == 0
	elseif type(value) == "table" then
		return next(value) == nil
	end

	return value == nil
end

module.IsInstance = function(value: any, className: string): boolean
	return typeof(value) == "Instance" and value:IsA(className)
end

return table.freeze(module)
