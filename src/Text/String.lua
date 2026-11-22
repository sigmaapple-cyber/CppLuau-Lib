--!strict
--[[
	Plain string operations.
]]

local module = {}

module.Trim = function(value: string): string
	return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
end

module.StartsWith = function(value: string, prefix: string): boolean
	return string.sub(value, 1, #prefix) == prefix
end

module.EndsWith = function(value: string, suffix: string): boolean
	return suffix == "" or string.sub(value, -#suffix) == suffix
end

module.Contains = function(value: string, target: string): boolean
	return string.find(value, target, 1, true) ~= nil
end

module.Split = function(value: string, separator: string): { string }
	assert(separator ~= "", "String separator cannot be empty")

	local raw = {}
	local start = 1

	while true do
		local first, last = string.find(value, separator, start, true)
		if first == nil then
			table.insert(raw, string.sub(value, start))
			break
		end

		table.insert(raw, string.sub(value, start, first - 1))
		start = last + 1
	end

	return raw
end

module.Join = function(values: { string }, separator: string?): string
	return table.concat(values, separator or "")
end

module.Replace = function(value: string, search: string, replacement: string): string
	assert(search ~= "", "String search cannot be empty")

	local raw = {}
	local start = 1

	while true do
		local first, last = string.find(value, search, start, true)
		if first == nil then
			table.insert(raw, string.sub(value, start))
			break
		end

		table.insert(raw, string.sub(value, start, first - 1))
		table.insert(raw, replacement)
		start = last + 1
	end

	return table.concat(raw)
end

module.Repeat = function(value: string, count: number): string
	assert(count % 1 == 0 and count >= 0, "String repeat count must be a non-negative integer")
	return string.rep(value, count)
end

module.Reverse = function(value: string): string
	return string.reverse(value)
end

module.Count = function(value: string, target: string): number
	assert(target ~= "", "String target cannot be empty")

	local count = 0
	local start = 1

	while true do
		local first, last = string.find(value, target, start, true)
		if first == nil then
			break
		end

		count += 1
		start = last + 1
	end

	return count
end

module.Lower = function(value: string): string
	return string.lower(value)
end

module.Upper = function(value: string): string
	return string.upper(value)
end

module.ByteLength = function(value: string): number
	return #value
end

return table.freeze(module)
