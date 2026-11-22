--!strict
--[[
	Sorting and merging algorithms for arrays.
]]

local module = {}

local function less<T>(callback: ((T, T) -> boolean)?): (T, T) -> boolean
	return callback or function(left, right)
		return (left :: any) < (right :: any)
	end
end

local function merge<T>(left: { T }, right: { T }, callback: (T, T) -> boolean): { T }
	local raw = table.create(#left + #right)
	local i = 1
	local j = 1

	while i <= #left and j <= #right do
		if callback(right[j], left[i]) then
			table.insert(raw, right[j])
			j += 1
		else
			table.insert(raw, left[i])
			i += 1
		end
	end

	while i <= #left do
		table.insert(raw, left[i])
		i += 1
	end

	while j <= #right do
		table.insert(raw, right[j])
		j += 1
	end

	return raw
end

local function split<T>(values: { T }, first: number, last: number, callback: (T, T) -> boolean): { T }
	if last - first < 1 then
		return { values[first] }
	end

	local middle = math.floor((first + last) / 2)
	local left = split(values, first, middle, callback)
	local right = split(values, middle + 1, last, callback)

	return merge(left, right, callback)
end

--[[
	Sorts an array in place and returns it.
]]
module.Sort = function<T>(values: { T }, callback: ((T, T) -> boolean)?): { T }
	table.sort(values, less(callback))
	return values
end

--[[
	Returns a stable sorted copy without modifying the input.
]]
module.StableSort = function<T>(values: { T }, callback: ((T, T) -> boolean)?): { T }
	if #values < 2 then
		return table.clone(values)
	end

	return split(values, 1, #values, less(callback))
end

--[[
	Merges two sorted arrays into a new sorted array.
]]
module.Merge = function<T>(left: { T }, right: { T }, callback: ((T, T) -> boolean)?): { T }
	return merge(left, right, less(callback))
end

--[[
	Checks whether an array is sorted.
]]
module.IsSorted = function<T>(values: { T }, callback: ((T, T) -> boolean)?): boolean
	local compare = less(callback)

	for idx = 2, #values do
		if compare(values[idx], values[idx - 1]) then
			return false
		end
	end

	return true
end

return table.freeze(module)
