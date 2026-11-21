--!strict
--[[
	Common numeric helpers for Luau values.
]]

local module = {}

--[[
	Restricts a number to an inclusive range.
]]
module.Clamp = function(value: number, minimum: number, maximum: number): number
	assert(minimum <= maximum, "Clamp minimum cannot exceed maximum")
	return math.clamp(value, minimum, maximum)
end

--[[
	Interpolates between two values.
]]
module.Lerp = function(from: number, to: number, alpha: number): number
	return from + (to - from) * alpha
end

--[[
	Converts a value from a range to a zero-to-one alpha.
]]
module.InverseLerp = function(from: number, to: number, value: number): number
	if from == to then
		return 0
	end

	return (value - from) / (to - from)
end

--[[
	Maps a value from one range into another.
]]
module.Remap = function(value: number, fromMinimum: number, fromMaximum: number, toMinimum: number, toMaximum: number): number
	local alpha = module.InverseLerp(fromMinimum, fromMaximum, value)
	return module.Lerp(toMinimum, toMaximum, alpha)
end

--[[
	Rounds a number to a given number of decimal places.
]]
module.Round = function(value: number, decimals: number?): number
	local factor = 10 ^ (decimals or 0)
	return math.floor(value * factor + 0.5) / factor
end

--[[
	Returns -1, 0, or 1 depending on the number's sign.
]]
module.Sign = function(value: number): number
	if value > 0 then
		return 1
	elseif value < 0 then
		return -1
	end

	return 0
end

--[[
	Wraps a number into a half-open range.
]]
module.Wrap = function(value: number, minimum: number, maximum: number): number
	assert(maximum > minimum, "Wrap maximum must exceed minimum")

	local range = maximum - minimum
	return ((value - minimum) % range) + minimum
end

--[[
	Checks whether a number is neither NaN nor positive or negative infinity.
]]
module.IsFinite = function(value: number): boolean
	return value == value and value > -math.huge and value < math.huge
end

--[[
	Returns the factorial of a non-negative integer.
]]
module.Factorial = function(value: number): number
	assert(value % 1 == 0 and value >= 0, "Factorial requires a non-negative integer")

	local result = 1

	for idx = 2, value do
		result *= idx
	end

	return result
end

return table.freeze(module)
