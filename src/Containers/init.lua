--!strict
--[[
	Container modules inspired by the C++ Standard Library.
]]

local module = {
	Array = require(script:WaitForChild("Array") :: ModuleScript),
	Vector = require(script:WaitForChild("Vector") :: ModuleScript),
	Deque = require(script:WaitForChild("Deque") :: ModuleScript),
	Stack = require(script:WaitForChild("Stack") :: ModuleScript),
	Queue = require(script:WaitForChild("Queue") :: ModuleScript),
	PriorityQueue = require(script:WaitForChild("PriorityQueue") :: ModuleScript),
	Map = require(script:WaitForChild("Map") :: ModuleScript),
	Set = require(script:WaitForChild("Set") :: ModuleScript),
}

return table.freeze(module)
