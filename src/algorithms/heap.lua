--!strict

type Compare<T> = (T, T) -> boolean

local module = {}

local function less<T>(callback: Compare<T>?): Compare<T>
	return callback or function(left, right)
		return (left :: any) < (right :: any)
	end
end

local function siftDown<T>(values: { T }, root: number, size: number, compare: Compare<T>)
	local parent = root

	while true do
		local child = parent * 2
		if child > size then
			return
		end

		if child + 1 <= size and compare(values[child], values[child + 1]) then
			child += 1
		end

		if not compare(values[parent], values[child]) then
			return
		end

		values[parent], values[child] = values[child], values[parent]
		parent = child
	end
end

module.IsHeap = function<T>(values: { T }, callback: Compare<T>?): boolean
	local compare = less(callback)

	for child = 2, #values do
		local parent = math.floor(child / 2)
		if compare(values[parent], values[child]) then
			return false
		end
	end

	return true
end

module.MakeHeap = function<T>(values: { T }, callback: Compare<T>?): { T }
	local compare = less(callback)

	for parent = math.floor(#values / 2), 1, -1 do
		siftDown(values, parent, #values, compare)
	end

	return values
end

module.PushHeap = function<T>(values: { T }, callback: Compare<T>?): { T }
	local compare = less(callback)
	local child = #values

	while child > 1 do
		local parent = math.floor(child / 2)
		if not compare(values[parent], values[child]) then
			break
		end

		values[parent], values[child] = values[child], values[parent]
		child = parent
	end

	return values
end

module.PopHeap = function<T>(values: { T }, callback: Compare<T>?): { T }
	local count = #values
	if count < 2 then
		return values
	end

	values[1], values[count] = values[count], values[1]
	siftDown(values, 1, count - 1, less(callback))

	return values
end

module.SortHeap = function<T>(values: { T }, callback: Compare<T>?): { T }
	local compare = less(callback)
	module.MakeHeap(values, compare)

	for last = #values, 2, -1 do
		values[1], values[last] = values[last], values[1]
		siftDown(values, 1, last - 1, compare)
	end

	return values
end

return table.freeze(module)
