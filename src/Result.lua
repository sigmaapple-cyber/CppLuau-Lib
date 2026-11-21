--!strict
--[[
	Represents either a successful value or an error value.
]]

type RawResultObject = {
	_IsOk: boolean,
	_Value: any,
}

type ProtoSchema = {
	Ok: (value: any) -> ResultObject,
	Err: (value: any) -> ResultObject,
	IsOk: (self: ResultObject) -> boolean,
	IsErr: (self: ResultObject) -> boolean,
	Unwrap: (self: ResultObject) -> any,
	UnwrapErr: (self: ResultObject) -> any,
	Expect: (self: ResultObject, message: string) -> any,
	Map: (self: ResultObject, callback: (any) -> any) -> ResultObject,
	MapErr: (self: ResultObject, callback: (any) -> any) -> ResultObject,
	AndThen: (self: ResultObject, callback: (any) -> ResultObject) -> ResultObject,
}

export type ResultObject = typeof(setmetatable({} :: RawResultObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a successful result.
]]
module.Ok = function(value: any)
	return (table.freeze(setmetatable({
		_IsOk = true;
		_Value = value;
	} :: RawResultObject, { __index = module }))) :: ResultObject
end

--[[
	Creates an error result.
]]
module.Err = function(value: any)
	return (table.freeze(setmetatable({
		_IsOk = false;
		_Value = value;
	} :: RawResultObject, { __index = module }))) :: ResultObject
end

--[[
	Checks whether the result contains a success value.
]]
module.IsOk = function(self: ResultObject)
	return self._IsOk
end

--[[
	Checks whether the result contains an error value.
]]
module.IsErr = function(self: ResultObject)
	return not self._IsOk
end

--[[
	Returns the success value or throws with the stored error.
]]
module.Unwrap = function(self: ResultObject)
	assert(self._IsOk, tostring(self._Value))
	return self._Value
end

--[[
	Returns the error value or throws when the result is successful.
]]
module.UnwrapErr = function(self: ResultObject)
	assert(not self._IsOk, "Cannot unwrap an error from a successful Result")
	return self._Value
end

--[[
	Returns the success value or throws with a custom message.
]]
module.Expect = function(self: ResultObject, message: string)
	assert(self._IsOk, message .. ": " .. tostring(self._Value))
	return self._Value
end

--[[
	Transforms a successful value and preserves errors.
]]
module.Map = function(self: ResultObject, callback: (any) -> any)
	assert(type(callback) == "function", "Result.Map callback must be a function")

	if self._IsOk then
		return module.Ok(callback(self._Value))
	end

	return self
end

--[[
	Transforms an error value and preserves successes.
]]
module.MapErr = function(self: ResultObject, callback: (any) -> any)
	assert(type(callback) == "function", "Result.MapErr callback must be a function")

	if self._IsOk then
		return self
	end

	return module.Err(callback(self._Value))
end

--[[
	Chains an operation which returns another Result.
]]
module.AndThen = function(self: ResultObject, callback: (any) -> ResultObject)
	assert(type(callback) == "function", "Result.AndThen callback must be a function")

	if not self._IsOk then
		return self
	end

	local result = callback(self._Value)
	assert(type(result) == "table" and type(result._IsOk) == "boolean", "Result.AndThen must return a Result")

	return result
end

return table.freeze(module)
