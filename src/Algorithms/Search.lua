--!strict
--[[
	Binary search algorithms for sorted arrays.
]]

local module = {}

local function less<T>(callback: ((T, T) -> boolean)?): (T, T) -> boolean
	return callback or function(left, right)
		return (left :: any) < (right :: any)
	end
end

--[[
	Returns the first position where the value could be inserted without breaking order.
]]
module.LowerBound = function<T>(values: { T }, target: T, callback: ((T, T) -> boolean)?): number
	local compare = less(callback)
	local first = 1
	local last = #values + 1

	while first < last do
		local middle = math.floor((first + last) / 2)

		if compare(values[middle], target) then
			first = middle + 1
		else
			last = middle
		end
	end

	return first
end

--[[
	Returns the first position after all values equivalent to the target.
]]
module.UpperBound = function<T>(values: { T }, target: T, callback: ((T, T) -> boolean)?): number
	local compare = less(callback)
	local first = 1
	local last = #values + 1

	while first < last do
		local middle = math.floor((first + last) / 2)

		if not compare(target, values[middle]) then
			first = middle + 1
		else
			last = middle
		end
	end

	return first
end

--[[
	Returns the first matching index or nil.
]]
module.BinarySearch = function<T>(values: { T }, target: T, callback: ((T, T) -> boolean)?): number?
	local compare = less(callback)
	local index = module.LowerBound(values, target, callback)

	if index <= #values and not compare(target, values[index]) and not compare(values[index], target) then
		return index
	end

	return nil
end

--[[
	Checks whether a sorted array contains the target.
]]
module.Contains = function<T>(values: { T }, target: T, callback: ((T, T) -> boolean)?): boolean
	return module.BinarySearch(values, target, callback) ~= nil
end

return table.freeze(module)
