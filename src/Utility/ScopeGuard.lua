--!strict
--[[
	Runs registered cleanup callbacks in reverse order.
]]

type RawScopeGuardObject = {
	_Callbacks: { () -> () },
	_Closed: boolean,
}

type ProtoSchema = {
	new: () -> ScopeGuardObject,
	Defer: (self: ScopeGuardObject, callback: () -> ()) -> ScopeGuardObject,
	Release: (self: ScopeGuardObject) -> (),
	Close: (self: ScopeGuardObject) -> (),
	IsClosed: (self: ScopeGuardObject) -> boolean,
	Count: (self: ScopeGuardObject) -> number,
}

export type ScopeGuardObject = typeof(setmetatable(
	{} :: RawScopeGuardObject,
	{ __index = {} :: ProtoSchema }
))

local module = {}

module.new = function()
	return (setmetatable({
		_Callbacks = {};
		_Closed = false;
	} :: RawScopeGuardObject, { __index = module })) :: ScopeGuardObject
end

module.Defer = function(self: ScopeGuardObject, callback: () -> ())
	assert(not self._Closed, "Cannot defer cleanup on a closed scope")
	assert(type(callback) == "function", "ScopeGuard.Defer expects a function")

	table.insert(self._Callbacks, callback)
	return self
end

--[[
	Disarms the guard without running callbacks.
]]
module.Release = function(self: ScopeGuardObject)
	self._Closed = true
	table.clear(self._Callbacks)
end

--[[
	Runs cleanup callbacks once, in reverse registration order.
]]
module.Close = function(self: ScopeGuardObject)
	if self._Closed then
		return
	end

	self._Closed = true

	for idx = #self._Callbacks, 1, -1 do
		local success, response = pcall(self._Callbacks[idx])
		if not success then
			warn(debug.traceback(tostring(response)))
		end
	end

	table.clear(self._Callbacks)
end

module.IsClosed = function(self: ScopeGuardObject)
	return self._Closed
end

module.Count = function(self: ScopeGuardObject)
	return #self._Callbacks
end

return module
