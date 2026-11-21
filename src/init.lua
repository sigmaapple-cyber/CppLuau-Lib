--!strict
--[[
	Public entry point for CppLuau-Lib.
]]

local module = {
	Class = require(script:WaitForChild("Class") :: ModuleScript),
	Struct = require(script:WaitForChild("Struct") :: ModuleScript),
	Enum = require(script:WaitForChild("Enum") :: ModuleScript),
}

return table.freeze(module)
