--!strict
--[[
	Core object and contract primitives.
]]

local module = {
	Class = require(script:WaitForChild("Class") :: ModuleScript),
	Struct = require(script:WaitForChild("Struct") :: ModuleScript),
	Enum = require(script:WaitForChild("Enum") :: ModuleScript),
	Interface = require(script:WaitForChild("Interface") :: ModuleScript),
	Namespace = require(script:WaitForChild("Namespace") :: ModuleScript),
}

return table.freeze(module)
