--!strict
--[[
	A duration represented internally in seconds.
]]

type RawDurationObject = {
	_Seconds: number,
}

type ProtoSchema = {
	new: (seconds: number) -> DurationObject,
	Seconds: (self: DurationObject) -> number,
	Milliseconds: (self: DurationObject) -> number,
	Minutes: (self: DurationObject) -> number,
	Hours: (self: DurationObject) -> number,
	Add: (self: DurationObject, other: DurationObject) -> DurationObject,
	Sub: (self: DurationObject, other: DurationObject) -> DurationObject,
	Scale: (self: DurationObject, factor: number) -> DurationObject,
	ToString: (self: DurationObject) -> string,
}

export type DurationObject = typeof(setmetatable({} :: RawDurationObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a duration from seconds.
]]
module.new = function(seconds: number)
	assert(seconds == seconds and math.abs(seconds) < math.huge, "Duration must be finite")

	return (setmetatable({
		_Seconds = seconds;
	} :: RawDurationObject, { __index = module })) :: DurationObject
end

--[[
	Returns the duration in seconds.
]]
module.Seconds = function(self: DurationObject)
	return self._Seconds
end

--[[
	Returns the duration in milliseconds.
]]
module.Milliseconds = function(self: DurationObject)
	return self._Seconds * 1000
end

--[[
	Returns the duration in minutes.
]]
module.Minutes = function(self: DurationObject)
	return self._Seconds / 60
end

--[[
	Returns the duration in hours.
]]
module.Hours = function(self: DurationObject)
	return self._Seconds / 3600
end

--[[
	Adds another duration.
]]
module.Add = function(self: DurationObject, other: DurationObject)
	return module.new(self._Seconds + other._Seconds)
end

--[[
	Subtracts another duration.
]]
module.Sub = function(self: DurationObject, other: DurationObject)
	return module.new(self._Seconds - other._Seconds)
end

--[[
	Scales the duration by a number.
]]
module.Scale = function(self: DurationObject, factor: number)
	return module.new(self._Seconds * factor)
end

--[[
	Returns a readable duration.
]]
module.ToString = function(self: DurationObject)
	return string.format("%.3fs", self._Seconds)
end

return module
