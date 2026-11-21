--!strict
--[[
	Registers cleanup callbacks and runs them in reverse order.
]]

type RawScopeObject = {
	_Callbacks: { () -> () },
	_Destroyed: boolean,
}

type ProtoSchema = {
	new: () -> ScopeObject,
	Defer: (self: ScopeObject, callback: () -> ()) -> ScopeObject,
	Destroy: (self: ScopeObject) -> (),
	IsDestroyed: (self: ScopeObject) -> boolean,
	Count: (self: ScopeObject) -> number,
}

export type ScopeObject = typeof(setmetatable({} :: RawScopeObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates an active cleanup scope.
]]
module.new = function()
	return (
		setmetatable(
			{
				_Callbacks = {},
				_Destroyed = false,
			} :: RawScopeObject,
			{ __index = module }
		)
	) :: ScopeObject
end

--[[
	Registers a cleanup callback.
]]
module.Defer = function(self: ScopeObject, callback: () -> ())
	assert(not self._Destroyed, "Cannot defer cleanup on a destroyed scope")
	assert(type(callback) == "function", "Scope.Defer callback must be a function")

	table.insert(self._Callbacks, callback)
	return self
end

--[[
	Runs registered cleanup callbacks once, in reverse order.
]]
module.Destroy = function(self: ScopeObject)
	if self._Destroyed then
		return
	end

	self._Destroyed = true

	for idx = #self._Callbacks, 1, -1 do
		local callback = self._Callbacks[idx]
		local success, response = pcall(callback)

		if not success then
			warn(debug.traceback(tostring(response)))
		end
	end

	table.clear(self._Callbacks)
end

--[[
	Checks whether the scope has already been destroyed.
]]
module.IsDestroyed = function(self: ScopeObject)
	return self._Destroyed
end

--[[
	Returns the number of pending cleanup callbacks.
]]
module.Count = function(self: ScopeObject)
	return #self._Callbacks
end

return module
