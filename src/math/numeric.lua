--!strict

local module = {}

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

module.GCD = function(left: number, right: number): number
	assert(left % 1 == 0 and right % 1 == 0, "GCD requires integers")

	left = math.abs(left)
	right = math.abs(right)

	while right ~= 0 do
		left, right = right, left % right
	end

	return left
end

module.LCM = function(left: number, right: number): number
	assert(left % 1 == 0 and right % 1 == 0, "LCM requires integers")

	if left == 0 or right == 0 then
		return 0
	end

	return math.abs((left / module.GCD(left, right)) * right)
end

module.InnerProduct = function<T, U>(left: { T }, right: { U }, initial: number?): number
	assert(#left == #right, "InnerProduct arrays must have the same length")

	local result = initial or 0

	for idx, value in left do
		result += (value :: any) * (right[idx] :: any)
	end

	return result
end

return table.freeze(module)
