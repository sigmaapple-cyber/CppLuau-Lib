--!strict
--[[
	Common scalar operations and numeric helpers.
]]

local module = {}

module.Abs = function(value: number): number
	return math.abs(value)
end

module.Clamp = function(value: number, minimum: number, maximum: number): number
	assert(minimum <= maximum, "Clamp minimum cannot exceed maximum")
	return math.clamp(value, minimum, maximum)
end

module.Lerp = function(from: number, to: number, alpha: number): number
	return from + (to - from) * alpha
end

module.InverseLerp = function(from: number, to: number, value: number): number
	if from == to then
		return 0
	end

	return (value - from) / (to - from)
end

module.Remap = function(
	value: number,
	fromMinimum: number,
	fromMaximum: number,
	toMinimum: number,
	toMaximum: number
): number
	local alpha = module.InverseLerp(fromMinimum, fromMaximum, value)
	return module.Lerp(toMinimum, toMaximum, alpha)
end

module.Round = function(value: number, decimals: number?): number
	local factor = 10 ^ (decimals or 0)
	return math.floor(value * factor + 0.5) / factor
end

module.Sign = function(value: number): number
	if value > 0 then
		return 1
	elseif value < 0 then
		return -1
	end

	return 0
end

module.Wrap = function(value: number, minimum: number, maximum: number): number
	assert(maximum > minimum, "Wrap maximum must exceed minimum")

	local range = maximum - minimum
	return ((value - minimum) % range) + minimum
end

module.IsFinite = function(value: number): boolean
	return value == value and value > -math.huge and value < math.huge
end

module.Factorial = function(value: number): number
	assert(value % 1 == 0 and value >= 0, "Factorial requires a non-negative integer")

	local result = 1
	for idx = 2, value do
		result *= idx
	end

	return result
end

module.Min = function(...: number): number
	return math.min(...)
end

module.Max = function(...: number): number
	return math.max(...)
end

module.Sum = function(values: { number }): number
	local result = 0

	for _, value in values do
		result += value
	end

	return result
end

module.Mean = function(values: { number }): number?
	if #values == 0 then
		return nil
	end

	return module.Sum(values) / #values
end

module.Median = function(values: { number }): number?
	if #values == 0 then
		return nil
	end

	local raw = table.clone(values)
	table.sort(raw)

	local middle = math.floor((#raw + 1) / 2)
	if #raw % 2 == 1 then
		return raw[middle]
	end

	return (raw[middle] + raw[middle + 1]) / 2
end

return table.freeze(module)
