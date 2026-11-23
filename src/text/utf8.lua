--!strict

local module = {}

local function length(value: string): number
	local count = utf8.len(value)
	assert(count ~= nil, "UTF-8 string is not valid")

	return count
end

module.IsValid = function(value: string): boolean
	return utf8.len(value) ~= nil
end

module.Length = function(value: string): number?
	return utf8.len(value)
end

module.ByteOffset = function(value: string, index: number): number
	local count = length(value)

	assert(index % 1 == 0 and index >= 1 and index <= count + 1, "UTF-8 character index out of bounds")

	if index == count + 1 then
		return #value + 1
	end

	return utf8.offset(value, index) :: number
end

module.Sub = function(value: string, first: number, last: number?): string
	local count = length(value)
	local finish = last or count

	assert(first % 1 == 0 and first >= 1 and first <= count + 1, "UTF-8 start index out of bounds")
	assert(finish % 1 == 0 and finish >= 0 and finish <= count, "UTF-8 end index out of bounds")

	if first > finish then
		return ""
	end

	local firstByte = module.ByteOffset(value, first)
	local afterLast = module.ByteOffset(value, finish + 1)

	return string.sub(value, firstByte, afterLast - 1)
end

module.Codepoints = function(value: string): { number }
	local raw = {}

	for _, codepoint in utf8.codes(value) do
		table.insert(raw, codepoint)
	end

	return raw
end

module.Char = function(...: number): string
	return utf8.char(...)
end

return table.freeze(module)
