--!strict
--[[
	A manually controlled elapsed-time timer.
]]

type RawTimerObject = {
	_StartedAt: number?,
	_Elapsed: number,
	_Running: boolean,
}

type ProtoSchema = {
	new: () -> TimerObject,
	Start: (self: TimerObject) -> TimerObject,
	Stop: (self: TimerObject) -> number,
	Reset: (self: TimerObject) -> TimerObject,
	Restart: (self: TimerObject) -> TimerObject,
	Elapsed: (self: TimerObject) -> number,
	IsRunning: (self: TimerObject) -> boolean,
}

export type TimerObject = typeof(setmetatable({} :: RawTimerObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a stopped timer.
]]
module.new = function()
	return (
		setmetatable(
			{
				_StartedAt = nil,
				_Elapsed = 0,
				_Running = false,
			} :: RawTimerObject,
			{ __index = module }
		)
	) :: TimerObject
end

--[[
	Starts the timer without resetting its accumulated time.
]]
module.Start = function(self: TimerObject)
	if not self._Running then
		self._StartedAt = os.clock()
		self._Running = true
	end

	return self
end

--[[
	Stops the timer and returns its accumulated elapsed time.
]]
module.Stop = function(self: TimerObject)
	if self._Running then
		self._Elapsed += os.clock() - (self._StartedAt :: number)
		self._StartedAt = nil
		self._Running = false
	end

	return self._Elapsed
end

--[[
	Clears the accumulated time and stops the timer.
]]
module.Reset = function(self: TimerObject)
	self._StartedAt = nil
	self._Elapsed = 0
	self._Running = false

	return self
end

--[[
	Restarts the timer from zero.
]]
module.Restart = function(self: TimerObject)
	self:Reset()
	return self:Start()
end

--[[
	Returns the current accumulated time.
]]
module.Elapsed = function(self: TimerObject)
	if not self._Running then
		return self._Elapsed
	end

	return self._Elapsed + os.clock() - (self._StartedAt :: number)
end

--[[
	Checks whether the timer is running.
]]
module.IsRunning = function(self: TimerObject)
	return self._Running
end

return module
