--!strict
--[[
	Small iterator helpers for arrays and numeric ranges.
]]

local module = {}

--[[
	Returns an iterator over a numeric half-open range.
]]
module.Range = function(first: number, last: number, step: number?): () -> number?
	local stride = step or 1
	assert(stride ~= 0, "Iterator.Range step cannot be zero")

	local current = first

	return function()
		if (stride > 0 and current >= last) or (stride < 0 and current <= last) then
			return nil
		end

		local value = current
		current += stride

		return value
	end
end

--[[
	Returns an iterator yielding each array index and value.
]]
module.Enumerate = function<T>(values: { T }): () -> (number?, T?)
	local index = 0

	return function()
		index += 1

		local value = values[index]
		if value == nil then
			return nil
		end

		return index, value
	end
end

--[[
	Returns an iterator yielding matching positions from two arrays.
]]
module.Zip = function<T, U>(left: { T }, right: { U }): () -> (T?, U?)
	local index = 0

	return function()
		index += 1

		if index > #left or index > #right then
			return nil
		end

		return left[index], right[index]
	end
end

--[[
	Returns an iterator over an array from last to first.
]]
module.Reverse = function<T>(values: { T }): () -> (number?, T?)
	local index = #values

	return function()
		if index < 1 then
			return nil
		end

		local current = index
		local value = values[current]
		index -= 1

		return current, value
	end
end

return table.freeze(module)
