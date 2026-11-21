--!strict
--[[
	Numeric algorithms for Luau arrays.
]]

local module = {}

--[[
	Accumulates values using addition or a custom operation.
]]
module.Accumulate = function<T, U>(values: { T }, initial: U, callback: ((U, T) -> U)?): U
	local result = initial

	for _, value in values do
		if callback then
			result = callback(result, value)
		else
			result = (result :: any) + (value :: any)
		end
	end

	return result
end

--[[
	Creates a sequence of numbers beginning at the initial value.
]]
module.Iota = function(count: number, initial: number?, step: number?): { number }
	assert(count % 1 == 0 and count >= 0, "Iota count must be a non-negative integer")

	local raw = table.create(count)
	local value = initial or 0
	local stride = step or 1

	for idx = 1, count do
		raw[idx] = value
		value += stride
	end

	return raw
end

--[[
	Returns the greatest common divisor of two integers.
]]
module.GCD = function(left: number, right: number): number
	assert(left % 1 == 0 and right % 1 == 0, "GCD requires integers")

	left = math.abs(left)
	right = math.abs(right)

	while right ~= 0 do
		left, right = right, left % right
	end

	return left
end

--[[
	Returns the least common multiple of two integers.
]]
module.LCM = function(left: number, right: number): number
	assert(left % 1 == 0 and right % 1 == 0, "LCM requires integers")

	if left == 0 or right == 0 then
		return 0
	end

	return math.abs((left / module.GCD(left, right)) * right)
end

--[[
	Returns the sum of products from two arrays plus an initial value.
]]
module.InnerProduct = function<T, U>(left: { T }, right: { U }, initial: number?): number
	local result = initial or 0

	for idx = 1, math.min(#left, #right) do
		result += (left[idx] :: any) * (right[idx] :: any)
	end

	return result
end

return table.freeze(module)
