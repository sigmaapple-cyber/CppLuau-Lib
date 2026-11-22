--!strict
--[[
	Numeric operations and mathematical types.
]]

local module = {
	Scalar = require(script:WaitForChild("Scalar") :: ModuleScript),
	Numeric = require(script:WaitForChild("Numeric") :: ModuleScript),
	Random = require(script:WaitForChild("Random") :: ModuleScript),
	Bit = require(script:WaitForChild("Bit") :: ModuleScript),
	Complex = require(script:WaitForChild("Complex") :: ModuleScript),
}

return table.freeze(module)
