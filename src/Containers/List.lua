--!strict
--[[
	A doubly linked list.
]]

type Node = {
	Value: any,
	Previous: Node?,
	Next: Node?,
}

type RawListObject = {
	_First: Node?,
	_Last: Node?,
	_Count: number,
}

type ProtoSchema = {
	new: (values: { any }?) -> ListObject,
	PushFront: (self: ListObject, value: any) -> ListObject,
	PushBack: (self: ListObject, value: any) -> ListObject,
	PopFront: (self: ListObject) -> any,
	PopBack: (self: ListObject) -> any,
	Front: (self: ListObject) -> any,
	Back: (self: ListObject) -> any,
	At: (self: ListObject, index: number) -> any,
	Insert: (self: ListObject, index: number, value: any) -> ListObject,
	Erase: (self: ListObject, index: number) -> any,
	Find: (self: ListObject, value: any) -> number?,
	Remove: (self: ListObject, value: any) -> boolean,
	Size: (self: ListObject) -> number,
	Empty: (self: ListObject) -> boolean,
	Clear: (self: ListObject) -> (),
	ToArray: (self: ListObject) -> { any },
}

export type ListObject = typeof(setmetatable({} :: RawListObject, { __index = {} :: ProtoSchema }))

local module = {}

local function nodeAt(self: ListObject, index: number): Node
	assert(index % 1 == 0 and index >= 1 and index <= self._Count, "List index out of bounds")

	local node
	if index <= self._Count / 2 then
		node = self._First

		for _ = 2, index do
			node = (node :: Node).Next
		end
	else
		node = self._Last

		for _ = self._Count - 1, index, -1 do
			node = (node :: Node).Previous
		end
	end

	return node :: Node
end

--[[
	Creates a list from an optional array.
]]
module.new = function(values: { any }?)
	assert(values == nil or type(values) == "table", "List values must be a table")

	local object = setmetatable({
		_First = nil;
		_Last = nil;
		_Count = 0;
	} :: RawListObject, { __index = module }) :: ListObject

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
module.PushFront = function(self: ListObject, value: any)
	assert(value ~= nil, "List cannot store nil")

	local node: Node = {
		Value = value;
		Previous = nil;
		Next = self._First;
	}

	if self._First then
		self._First.Previous = node
	else
		self._Last = node
	end

	self._First = node
	self._Count += 1

	return self
end

--[[
	Adds a value after the current last node.
]]
module.PushBack = function(self: ListObject, value: any)
	assert(value ~= nil, "List cannot store nil")

	local node: Node = {
		Value = value;
		Previous = self._Last;
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
module.PopFront = function(self: ListObject)
	local node = self._First
	if not node then
		return nil
	end

	self._First = node.Next
	if self._First then
		self._First.Previous = nil
	else
		self._Last = nil
	end

	self._Count -= 1
	return node.Value
end

--[[
	Removes and returns the last value.
]]
module.PopBack = function(self: ListObject)
	local node = self._Last
	if not node then
		return nil
	end

	self._Last = node.Previous
	if self._Last then
		self._Last.Next = nil
	else
		self._First = nil
	end

	self._Count -= 1
	return node.Value
end

--[[
	Returns the first value.
]]
module.Front = function(self: ListObject)
	return self._First and self._First.Value
end

--[[
	Returns the last value.
]]
module.Back = function(self: ListObject)
	return self._Last and self._Last.Value
end

--[[
	Returns a value at a one-based index.
]]
module.At = function(self: ListObject, index: number)
	return nodeAt(self, index).Value
end

--[[
	Inserts a value before a one-based position. Count + 1 appends.
]]
module.Insert = function(self: ListObject, index: number, value: any)
	assert(index % 1 == 0 and index >= 1 and index <= self._Count + 1, "List index out of bounds")
	assert(value ~= nil, "List cannot store nil")

	if index == 1 then
		return self:PushFront(value)
	elseif index == self._Count + 1 then
		return self:PushBack(value)
	end

	local nextNode = nodeAt(self, index)
	local previous = nextNode.Previous
	local node: Node = {
		Value = value;
		Previous = previous;
		Next = nextNode;
	}

	(previous :: Node).Next = node
	nextNode.Previous = node
	self._Count += 1

	return self
end

--[[
	Removes and returns the value at a one-based position.
]]
module.Erase = function(self: ListObject, index: number)
	local node = nodeAt(self, index)

	if node.Previous then
		node.Previous.Next = node.Next
	else
		self._First = node.Next
	end

	if node.Next then
		node.Next.Previous = node.Previous
	else
		self._Last = node.Previous
	end

	self._Count -= 1
	return node.Value
end

--[[
	Returns the first index containing the supplied value.
]]
module.Find = function(self: ListObject, value: any)
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
module.Remove = function(self: ListObject, value: any)
	local index = self:Find(value)
	if not index then
		return false
	end

	self:Erase(index)
	return true
end

--[[
	Returns the number of nodes.
]]
module.Size = function(self: ListObject)
	return self._Count
end

--[[
	Checks whether the list is empty.
]]
module.Empty = function(self: ListObject)
	return self._Count == 0
end

--[[
	Removes every node.
]]
module.Clear = function(self: ListObject)
	self._First = nil
	self._Last = nil
	self._Count = 0
end

--[[
	Returns a shallow array copy in list order.
]]
module.ToArray = function(self: ListObject)
	local raw = table.create(self._Count)
	local node = self._First

	while node do
		table.insert(raw, node.Value)
		node = node.Next
	end

	return raw
end

return module
