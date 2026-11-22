--!strict
--[[
	Sequential and associative containers.
]]

local module = {
	Array = require(script:WaitForChild("Array") :: ModuleScript),
	Vector = require(script:WaitForChild("Vector") :: ModuleScript),
	Deque = require(script:WaitForChild("Deque") :: ModuleScript),
	List = require(script:WaitForChild("List") :: ModuleScript),
	ForwardList = require(script:WaitForChild("ForwardList") :: ModuleScript),
	Stack = require(script:WaitForChild("Stack") :: ModuleScript),
	Queue = require(script:WaitForChild("Queue") :: ModuleScript),
	PriorityQueue = require(script:WaitForChild("PriorityQueue") :: ModuleScript),
	HashMap = require(script:WaitForChild("HashMap") :: ModuleScript),
	HashSet = require(script:WaitForChild("HashSet") :: ModuleScript),
	Span = require(script:WaitForChild("Span") :: ModuleScript),
	BitSet = require(script:WaitForChild("BitSet") :: ModuleScript),
}

return table.freeze(module)
