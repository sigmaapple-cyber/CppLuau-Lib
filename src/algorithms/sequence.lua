--!strict
--[[
	Common algorithms for Luau arrays.
]]

local module = {}

--[[
	Returns the first value matching a predicate.
]]
module.Find = function<T>(values: { T }, callback: (T, number) -> boolean): T?
	for idx, value in values do
		if callback(value, idx) then
			return value
		end
	end

	return nil
end

--[[
	Returns the index of the first matching value.
]]
module.FindIndex = function<T>(values: { T }, callback: (T, number) -> boolean): number?
	for idx, value in values do
		if callback(value, idx) then
			return idx
		end
	end

	return nil
end

--[[
	Counts values which match a predicate.
]]
module.Count = function<T>(values: { T }, callback: (T, number) -> boolean): number
	local count = 0

	for idx, value in values do
		if callback(value, idx) then
			count += 1
		end
	end

	return count
end

--[[
	Checks whether at least one value matches a predicate.
]]
module.Any = function<T>(values: { T }, callback: (T, number) -> boolean): boolean
	for idx, value in values do
		if callback(value, idx) then
			return true
		end
	end

	return false
end

--[[
	Checks whether every value matches a predicate.
]]
module.All = function<T>(values: { T }, callback: (T, number) -> boolean): boolean
	for idx, value in values do
		if not callback(value, idx) then
			return false
		end
	end

	return true
end

--[[
	Returns a new array containing values which match a predicate.
]]
module.Filter = function<T>(values: { T }, callback: (T, number) -> boolean): { T }
	local raw = {}

	for idx, value in values do
		if callback(value, idx) then
			table.insert(raw, value)
		end
	end

	return raw
end

--[[
	Transforms each value into a new array.
]]
module.Map = function<T, U>(values: { T }, callback: (T, number) -> U): { U }
	local raw = {}

	for idx, value in values do
		table.insert(raw, callback(value, idx))
	end

	return raw
end

--[[
	Reduces an array to one value, starting from an initial value.
]]
module.Reduce = function<T, U>(values: { T }, callback: (U, T, number) -> U, initial: U): U
	local result = initial

	for idx, value in values do
		result = callback(result, value, idx)
	end

	return result
end

--[[
	Calls a function for each value.
]]
module.ForEach = function<T>(values: { T }, callback: (T, number) -> ())
	for idx, value in values do
		callback(value, idx)
	end
end

--[[
	Returns a sorted copy without changing the original array.
]]
module.Sorted = function<T>(values: { T }, callback: ((T, T) -> boolean)?): { T }
	local raw = table.clone(values)
	table.sort(raw, callback)
	return raw
end

--[[
	Returns a reversed copy without changing the original array.
]]
module.Reversed = function<T>(values: { T }): { T }
	local raw = table.clone(values)
	local left = 1
	local right = #raw

	while left < right do
		raw[left], raw[right] = raw[right], raw[left]
		left += 1
		right -= 1
	end

	return raw
end

--[[
	Returns the number of times a value occurs.
]]
module.CountValue = function<T>(values: { T }, target: T): number
	local count = 0

	for _, value in values do
		if value == target then
			count += 1
		end
	end

	return count
end

--[[
	Returns a new array with duplicate values removed, preserving order.
]]
module.Unique = function<T>(values: { T }): { T }
	local raw = {}
	local seen = {}

	for _, value in values do
		if not seen[value] then
			seen[value] = true
			table.insert(raw, value)
		end
	end

	return raw
end

return table.freeze(module)
