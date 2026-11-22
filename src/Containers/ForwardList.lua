--!strict
--[[
	A singly linked list.
]]

type Node = {
	Value: any,
	Next: Node?,
}

type RawForwardListObject = {
	_First: Node?,
	_Last: Node?,
	_Count: number,
}

type ProtoSchema = {
	new: (values: { any }?) -> ForwardListObject,
	PushFront: (self: ForwardListObject, value: any) -> ForwardListObject,
	PushBack: (self: ForwardListObject, value: any) -> ForwardListObject,
	PopFront: (self: ForwardListObject) -> any,
	Front: (self: ForwardListObject) -> any,
	Back: (self: ForwardListObject) -> any,
	InsertAfter: (self: ForwardListObject, index: number, value: any) -> ForwardListObject,
	EraseAfter: (self: ForwardListObject, index: number) -> any,
	Find: (self: ForwardListObject, value: any) -> number?,
	Remove: (self: ForwardListObject, value: any) -> boolean,
	Size: (self: ForwardListObject) -> number,
	Empty: (self: ForwardListObject) -> boolean,
	Clear: (self: ForwardListObject) -> (),
	ToArray: (self: ForwardListObject) -> { any },
}

export type ForwardListObject = typeof(setmetatable(
	{} :: RawForwardListObject,
	{ __index = {} :: ProtoSchema }
))

local module = {}

local function nodeAt(self: ForwardListObject, index: number): Node
	assert(index % 1 == 0 and index >= 1 and index <= self._Count, "ForwardList index out of bounds")

	local node = self._First
	for _ = 2, index do
		node = (node :: Node).Next
	end

	return node :: Node
end

--[[
	Creates a forward list from an optional array.
]]
module.new = function(values: { any }?)
	assert(values == nil or type(values) == "table", "ForwardList values must be a table")

	local object = setmetatable({
		_First = nil;
		_Last = nil;
		_Count = 0;
	} :: RawForwardListObject, { __index = module }) :: ForwardListObject

	if values then
		for _, value in ipairs(values) do
			object:PushBack(value)
		end
	end

	return object
end

--[[
	Adds a value before the current first node.
]]
module.PushFront = function(self: ForwardListObject, value: any)
	assert(value ~= nil, "ForwardList cannot store nil")

	local node: Node = {
		Value = value;
		Next = self._First;
	}

	self._First = node
	if not self._Last then
		self._Last = node
	end

	self._Count += 1
	return self
end

--[[
	Adds a value after the current last node.
]]
module.PushBack = function(self: ForwardListObject, value: any)
	assert(value ~= nil, "ForwardList cannot store nil")

	local node: Node = {
		Value = value;
		Next = nil;
	}

	if self._Last then
		self._Last.Next = node
	else
		self._First = node
	end

	self._Last = node
	self._Count += 1

	return self
end

--[[
	Removes and returns the first value.
]]
module.PopFront = function(self: ForwardListObject)
	local node = self._First
	if not node then
		return nil
	end

	self._First = node.Next
	if not self._First then
		self._Last = nil
	end

	self._Count -= 1
	return node.Value
end

--[[
	Returns the first value.
]]
module.Front = function(self: ForwardListObject)
	return self._First and self._First.Value
end

--[[
	Returns the last value.
]]
module.Back = function(self: ForwardListObject)
	return self._Last and self._Last.Value
end

--[[
	Inserts after a one-based node index. Zero inserts at the front.
]]
module.InsertAfter = function(self: ForwardListObject, index: number, value: any)
	assert(index % 1 == 0 and index >= 0 and index <= self._Count, "ForwardList index out of bounds")
	assert(value ~= nil, "ForwardList cannot store nil")

	if index == 0 then
		return self:PushFront(value)
	elseif index == self._Count then
		return self:PushBack(value)
	end

	local previous = nodeAt(self, index)
	local node: Node = {
		Value = value;
		Next = previous.Next;
	}

	previous.Next = node
	self._Count += 1

	return self
end

--[[
	Removes and returns the node after a one-based index. Zero removes the first node.
]]
module.EraseAfter = function(self: ForwardListObject, index: number)
	assert(index % 1 == 0 and index >= 0 and index <= self._Count, "ForwardList index out of bounds")

	local previous = if index == 0 then nil else nodeAt(self, index)
	local node = if previous then previous.Next else self._First
	if not node then
		return nil
	end

	if previous then
		previous.Next = node.Next
	else
		self._First = node.Next
	end

	if self._Last == node then
		self._Last = previous
	end

	self._Count -= 1
	return node.Value
end

--[[
	Returns the first index containing the supplied value.
]]
module.Find = function(self: ForwardListObject, value: any)
	local node = self._First
	local index = 1

	while node do
		if node.Value == value then
			return index
		end

		node = node.Next
		index += 1
	end

	return nil
end

--[[
	Removes the first occurrence of a value.
]]
module.Remove = function(self: ForwardListObject, value: any)
	local index = self:Find(value)
	if not index then
		return false
	end

	self:EraseAfter(index - 1)
	return true
end

--[[
	Returns the number of nodes.
]]
module.Size = function(self: ForwardListObject)
	return self._Count
end

--[[
	Checks whether the list is empty.
]]
module.Empty = function(self: ForwardListObject)
	return self._Count == 0
end

--[[
	Removes every node.
]]
module.Clear = function(self: ForwardListObject)
	self._First = nil
	self._Last = nil
	self._Count = 0
end

--[[
	Returns a shallow array copy in list order.
]]
module.ToArray = function(self: ForwardListObject)
	local raw = table.create(self._Count)
	local node = self._First

	while node do
		table.insert(raw, node.Value)
		node = node.Next
	end

	return raw
end

return module
