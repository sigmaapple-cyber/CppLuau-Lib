--!strict
--[[
	A growable byte buffer with cursor-based reading.
]]

type RawBufferObject = {
	_Data: buffer,
	_Length: number,
	_Cursor: number,
}

type ProtoSchema = {
	new: (capacity: number?) -> BufferObject,
	Position: (self: BufferObject) -> number,
	Seek: (self: BufferObject, position: number) -> BufferObject,
	Size: (self: BufferObject) -> number,
	Capacity: (self: BufferObject) -> number,
	WriteU8: (self: BufferObject, value: number) -> BufferObject,
	WriteI8: (self: BufferObject, value: number) -> BufferObject,
	WriteU16: (self: BufferObject, value: number) -> BufferObject,
	WriteI16: (self: BufferObject, value: number) -> BufferObject,
	WriteU32: (self: BufferObject, value: number) -> BufferObject,
	WriteI32: (self: BufferObject, value: number) -> BufferObject,
	WriteF32: (self: BufferObject, value: number) -> BufferObject,
	WriteF64: (self: BufferObject, value: number) -> BufferObject,
	WriteString: (self: BufferObject, value: string) -> BufferObject,
	WriteBytes: (self: BufferObject, value: buffer, first: number?, count: number?) -> BufferObject,
	ReadU8: (self: BufferObject) -> number,
	ReadI8: (self: BufferObject) -> number,
	ReadU16: (self: BufferObject) -> number,
	ReadI16: (self: BufferObject) -> number,
	ReadU32: (self: BufferObject) -> number,
	ReadI32: (self: BufferObject) -> number,
	ReadF32: (self: BufferObject) -> number,
	ReadF64: (self: BufferObject) -> number,
	ReadString: (self: BufferObject, count: number) -> string,
	ToBuffer: (self: BufferObject) -> buffer,
	ToString: (self: BufferObject) -> string,
	Clear: (self: BufferObject) -> (),
}

export type BufferObject = typeof(setmetatable({} :: RawBufferObject, { __index = {} :: ProtoSchema }))

local module = {}

local function ensure(self: BufferObject, count: number)
	local required = self._Cursor + count
	local capacity = buffer.len(self._Data)

	if required <= capacity then
		return
	end

	local nextCapacity = math.max(16, capacity)
	while nextCapacity < required do
		nextCapacity *= 2
	end

	local raw = buffer.create(nextCapacity)
	buffer.copy(raw, 0, self._Data, 0, self._Length)
	self._Data = raw
end

local function checkRead(self: BufferObject, count: number)
	assert(count % 1 == 0 and count >= 0, "Buffer read size must be a non-negative integer")
	assert(self._Cursor + count <= self._Length, "Buffer read out of bounds")
end

--[[
	Creates an empty buffer with an optional initial capacity.
]]
module.new = function(capacity: number?)
	local size = capacity or 16
	assert(size % 1 == 0 and size >= 0, "Buffer capacity must be a non-negative integer")

	return (setmetatable({
		_Data = buffer.create(size);
		_Length = 0;
		_Cursor = 0;
	} :: RawBufferObject, { __index = module })) :: BufferObject
end

--[[
	Returns the current read/write cursor as a zero-based offset.
]]
module.Position = function(self: BufferObject)
	return self._Cursor
end

--[[
	Moves the cursor to a zero-based offset.
]]
module.Seek = function(self: BufferObject, position: number)
	assert(position % 1 == 0 and position >= 0 and position <= self._Length, "Buffer position out of bounds")
	self._Cursor = position
	return self
end

--[[
	Returns the number of written bytes.
]]
module.Size = function(self: BufferObject)
	return self._Length
end

--[[
	Returns the allocated byte capacity.
]]
module.Capacity = function(self: BufferObject)
	return buffer.len(self._Data)
end

local function write(self: BufferObject, count: number, callback: (buffer, number) -> ())
	ensure(self, count)
	callback(self._Data, self._Cursor)
	self._Cursor += count
	self._Length = math.max(self._Length, self._Cursor)
end

local function read(self: BufferObject, count: number, callback: (buffer, number) -> any): any
	checkRead(self, count)

	local value = callback(self._Data, self._Cursor)
	self._Cursor += count

	return value
end

--[[
	Writes an unsigned 8-bit integer.
]]
module.WriteU8 = function(self: BufferObject, value: number)
	assert(value % 1 == 0 and value >= 0 and value <= 0xFF, "WriteU8 out of range")
	write(self, 1, function(raw, idx)
		buffer.writeu8(raw, idx, value)
	end)
	return self
end

--[[
	Writes a signed 8-bit integer.
]]
module.WriteI8 = function(self: BufferObject, value: number)
	assert(value % 1 == 0 and value >= -0x80 and value <= 0x7F, "WriteI8 out of range")
	write(self, 1, function(raw, idx)
		buffer.writei8(raw, idx, value)
	end)
	return self
end

--[[
	Writes an unsigned 16-bit integer in little-endian order.
]]
module.WriteU16 = function(self: BufferObject, value: number)
	assert(value % 1 == 0 and value >= 0 and value <= 0xFFFF, "WriteU16 out of range")
	write(self, 2, function(raw, idx)
		buffer.writeu16(raw, idx, value)
	end)
	return self
end

--[[
	Writes a signed 16-bit integer in little-endian order.
]]
module.WriteI16 = function(self: BufferObject, value: number)
	assert(value % 1 == 0 and value >= -0x8000 and value <= 0x7FFF, "WriteI16 out of range")
	write(self, 2, function(raw, idx)
		buffer.writei16(raw, idx, value)
	end)
	return self
end

--[[
	Writes an unsigned 32-bit integer in little-endian order.
]]
module.WriteU32 = function(self: BufferObject, value: number)
	assert(value % 1 == 0 and value >= 0 and value <= 0xFFFFFFFF, "WriteU32 out of range")
	write(self, 4, function(raw, idx)
		buffer.writeu32(raw, idx, value)
	end)
	return self
end

--[[
	Writes a signed 32-bit integer in little-endian order.
]]
module.WriteI32 = function(self: BufferObject, value: number)
	assert(value % 1 == 0 and value >= -0x80000000 and value <= 0x7FFFFFFF, "WriteI32 out of range")
	write(self, 4, function(raw, idx)
		buffer.writei32(raw, idx, value)
	end)
	return self
end

--[[
	Writes a 32-bit floating-point number in little-endian order.
]]
module.WriteF32 = function(self: BufferObject, value: number)
	write(self, 4, function(raw, idx)
		buffer.writef32(raw, idx, value)
	end)
	return self
end

--[[
	Writes a 64-bit floating-point number in little-endian order.
]]
module.WriteF64 = function(self: BufferObject, value: number)
	write(self, 8, function(raw, idx)
		buffer.writef64(raw, idx, value)
	end)
	return self
end

--[[
	Writes the bytes of a string.
]]
module.WriteString = function(self: BufferObject, value: string)
	local count = #value
	write(self, count, function(raw, idx)
		buffer.writestring(raw, idx, value)
	end)
	return self
end

--[[
	Copies a range of bytes from another buffer.
]]
module.WriteBytes = function(self: BufferObject, value: buffer, first: number?, count: number?)
	local start = first or 0
	local length = count or (buffer.len(value) - start)

	assert(start % 1 == 0 and start >= 0 and start <= buffer.len(value), "WriteBytes source offset out of bounds")
	assert(length % 1 == 0 and length >= 0 and start + length <= buffer.len(value), "WriteBytes length out of bounds")

	write(self, length, function(raw, idx)
		buffer.copy(raw, idx, value, start, length)
	end)

	return self
end

--[[
	Reads an unsigned 8-bit integer.
]]
module.ReadU8 = function(self: BufferObject)
	return read(self, 1, buffer.readu8)
end

--[[
	Reads a signed 8-bit integer.
]]
module.ReadI8 = function(self: BufferObject)
	return read(self, 1, buffer.readi8)
end

--[[
	Reads an unsigned 16-bit integer.
]]
module.ReadU16 = function(self: BufferObject)
	return read(self, 2, buffer.readu16)
end

--[[
	Reads a signed 16-bit integer.
]]
module.ReadI16 = function(self: BufferObject)
	return read(self, 2, buffer.readi16)
end

--[[
	Reads an unsigned 32-bit integer.
]]
module.ReadU32 = function(self: BufferObject)
	return read(self, 4, buffer.readu32)
end

--[[
	Reads a signed 32-bit integer.
]]
module.ReadI32 = function(self: BufferObject)
	return read(self, 4, buffer.readi32)
end

--[[
	Reads a 32-bit floating-point number.
]]
module.ReadF32 = function(self: BufferObject)
	return read(self, 4, buffer.readf32)
end

--[[
	Reads a 64-bit floating-point number.
]]
module.ReadF64 = function(self: BufferObject)
	return read(self, 8, buffer.readf64)
end

--[[
	Reads a fixed number of bytes as a string.
]]
module.ReadString = function(self: BufferObject, count: number)
	return read(self, count, function(raw, idx)
		return buffer.readstring(raw, idx, count)
	end)
end

--[[
	Returns a copy of the written bytes.
]]
module.ToBuffer = function(self: BufferObject)
	local raw = buffer.create(self._Length)
	buffer.copy(raw, 0, self._Data, 0, self._Length)
	return raw
end

--[[
	Returns the written bytes as a string.
]]
module.ToString = function(self: BufferObject)
	return buffer.tostring(self:ToBuffer())
end

--[[
	Clears the written data and resets the cursor.
]]
module.Clear = function(self: BufferObject)
	self._Length = 0
	self._Cursor = 0
end

return module
