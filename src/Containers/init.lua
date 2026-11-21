--!strict
--[[
	Container modules inspired by the C++ Standard Library.
]]

local module = {
	Vector = require(script:WaitForChild("Vector") :: ModuleScript),
	Stack = require(script:WaitForChild("Stack") :: ModuleScript),
	Queue = require(script:WaitForChild("Queue") :: ModuleScript),
	Map = require(script:WaitForChild("Map") :: ModuleScript),
	Set = require(script:WaitForChild("Set") :: ModuleScript),
}

return table.freeze(module)
