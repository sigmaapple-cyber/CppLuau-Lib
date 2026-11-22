--!strict
--[[
	Public entry point for CppLuau.
]]

local module = {
	Core = require(script:WaitForChild("Core") :: ModuleScript),
	Values = require(script:WaitForChild("Values") :: ModuleScript),
	Containers = require(script:WaitForChild("Containers") :: ModuleScript),
	Algorithms = require(script:WaitForChild("Algorithms") :: ModuleScript),
	Math = require(script:WaitForChild("Math") :: ModuleScript),
	Text = require(script:WaitForChild("Text") :: ModuleScript),
	Utility = require(script:WaitForChild("Utility") :: ModuleScript),
	Time = require(script:WaitForChild("Time") :: ModuleScript),
	Binary = require(script:WaitForChild("Binary") :: ModuleScript),
}

return table.freeze(module)
