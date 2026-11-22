--!strict
--[[
	String formatting helpers.
]]

local module = {}

--[[
	Formats values using Luau's string.format rules.
]]
module.Format = function(template: string, ...): string
	return string.format(template, ...)
end

--[[
	Replaces zero-based numbered fields such as {0} and {1}.
]]
module.Template = function(template: string, ...): string
	local values = table.pack(...)

	return (string.gsub(template, "{(%d+)}", function(index)
		local value = values[tonumber(index) + 1]
		if value == nil then
			return "{" .. index .. "}"
		end

		return tostring(value)
	end))
end

--[[
	Pads a string on the left to a minimum byte width.
]]
module.PadLeft = function(value: string, width: number, fill: string?): string
	local pad = fill or " "
	assert(#pad > 0, "Format padding cannot be empty")
	assert(width % 1 == 0 and width >= 0, "Format width must be a non-negative integer")

	local count = width - #value
	if count <= 0 then
		return value
	end

	return string.rep(pad, math.ceil(count / #pad)):sub(1, count) .. value
end

--[[
	Pads a string on the right to a minimum byte width.
]]
module.PadRight = function(value: string, width: number, fill: string?): string
	local pad = fill or " "
	assert(#pad > 0, "Format padding cannot be empty")
	assert(width % 1 == 0 and width >= 0, "Format width must be a non-negative integer")

	local count = width - #value
	if count <= 0 then
		return value
	end

	return value .. string.rep(pad, math.ceil(count / #pad)):sub(1, count)
end

--[[
	Joins values after converting each one to a string.
]]
module.Join = function(values: { any }, separator: string?): string
	local raw = table.create(#values)

	for idx, value in values do
		raw[idx] = tostring(value)
	end

	return table.concat(raw, separator or "")
end

return table.freeze(module)
