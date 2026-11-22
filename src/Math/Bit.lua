--!strict
--[[
	Unsigned 32-bit bitwise helpers.
]]

local module = {}

--[[
	Returns the bitwise AND of its arguments.
]]
module.And = function(...): number
	return bit32.band(...)
end

--[[
	Returns the bitwise OR of its arguments.
]]
module.Or = function(...): number
	return bit32.bor(...)
end

--[[
	Returns the bitwise XOR of its arguments.
]]
module.Xor = function(...): number
	return bit32.bxor(...)
end

--[[
	Returns the bitwise complement.
]]
module.Not = function(value: number): number
	return bit32.bnot(value)
end

--[[
	Shifts bits left.
]]
module.ShiftLeft = function(value: number, amount: number): number
	return bit32.lshift(value, amount)
end

--[[
	Shifts bits right without sign extension.
]]
module.ShiftRight = function(value: number, amount: number): number
	return bit32.rshift(value, amount)
end

--[[
	Rotates bits left.
]]
module.RotateLeft = function(value: number, amount: number): number
	return bit32.lrotate(value, amount)
end

--[[
	Rotates bits right.
]]
module.RotateRight = function(value: number, amount: number): number
	return bit32.rrotate(value, amount)
end

--[[
	Extracts a bit field.
]]
module.Extract = function(value: number, field: number, width: number?): number
	return bit32.extract(value, field, width)
end

--[[
	Replaces a bit field.
]]
module.Replace = function(value: number, replacement: number, field: number, width: number?): number
	return bit32.replace(value, replacement, field, width)
end

return table.freeze(module)
