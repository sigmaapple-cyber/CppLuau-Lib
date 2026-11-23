--!strict
--[[
	Small helpers for composing and adapting functions.
]]

type Callback = (...any) -> ...any
type PackedValues = {
	[number]: any,
	n: number,
}

local module = {}

--[[
	Returns the input unchanged.
]]
module.Identity = function(value: any)
	return value
end

--[[
	Creates a function which always returns the supplied value.
]]
module.Constant = function(value: any)
	return function()
		return value
	end
end

--[[
	Composes two functions, applying inner before outer.
]]
module.Compose = function(outer: Callback, inner: Callback)
	assert(type(outer) == "function" and type(inner) == "function", "Compose expects functions")

	return function(...)
		return outer(inner(...))
	end
end

--[[
	Pipes the output of the first function into the second.
]]
module.Pipe = function(first: Callback, second: Callback)
	assert(type(first) == "function" and type(second) == "function", "Pipe expects functions")

	return function(...)
		return second(first(...))
	end
end

--[[
	Binds leading arguments to a function.
]]
module.Bind = function(callback: Callback, ...)
	assert(type(callback) == "function", "Bind expects a function")

	local bound = table.pack(...)

	return function(...)
		local args = table.create(bound.n + select("#", ...))

		for idx = 1, bound.n do
			args[idx] = bound[idx]
		end

		local count = select("#", ...)
		for idx = 1, count do
			args[bound.n + idx] = select(idx, ...)
		end

		return callback(table.unpack(args, 1, bound.n + count))
	end
end

--[[
	Creates a function which runs its callback only once and caches its return values.
]]
module.Once = function(callback: Callback)
	assert(type(callback) == "function", "Once expects a function")

	local called = false
	local results: PackedValues? = nil

	return function(...)
		if not called then
			results = table.pack(callback(...))
			called = true
		end

		local values = results :: PackedValues
		return table.unpack(values, 1, values.n)
	end
end

return table.freeze(module)
