--!strict
--[[
	Value wrappers and compound values.
]]

local module = {
	Optional = require(script:WaitForChild("Optional") :: ModuleScript),
	Result = require(script:WaitForChild("Result") :: ModuleScript),
	Pair = require(script:WaitForChild("Pair") :: ModuleScript),
	Tuple = require(script:WaitForChild("Tuple") :: ModuleScript),
	Variant = require(script:WaitForChild("Variant") :: ModuleScript),
	Reference = require(script:WaitForChild("Reference") :: ModuleScript),
}

return table.freeze(module)
