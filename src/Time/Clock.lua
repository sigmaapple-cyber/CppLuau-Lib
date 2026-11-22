--!strict
--[[
	Clock helpers for monotonic and wall-clock time.
]]

local module = {}

--[[
	Returns elapsed time from a monotonic clock.
]]
module.Now = function(): number
	return os.clock()
end

--[[
	Returns the current Unix timestamp in seconds.
]]
module.Unix = function(): number
	return DateTime.now().UnixTimestampMillis / 1000
end

--[[
	Returns the current Unix timestamp in milliseconds.
]]
module.UnixMilliseconds = function(): number
	return DateTime.now().UnixTimestampMillis
end

--[[
	Measures a callback's elapsed execution time in seconds.
]]
module.Measure = function(callback: () -> ...any): (number, ...any)
	assert(type(callback) == "function", "Clock.Measure expects a function")

	local start = os.clock()
	local values = table.pack(callback())
	return os.clock() - start, table.unpack(values, 1, values.n)
end

--[[
	Waits for a duration and returns the actual elapsed time.
]]
module.Sleep = function(seconds: number): number
	assert(seconds >= 0, "Clock.Sleep duration cannot be negative")

	local start = os.clock()
	task.wait(seconds)

	return os.clock() - start
end

return table.freeze(module)
