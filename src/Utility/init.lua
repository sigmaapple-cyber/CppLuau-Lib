--!strict
--[[
	General-purpose runtime utilities.
]]

local module = {
	Functional = require(script:WaitForChild("Functional") :: ModuleScript),
	Iterator = require(script:WaitForChild("Iterator") :: ModuleScript),
	TypeInfo = require(script:WaitForChild("TypeInfo") :: ModuleScript),
	ScopeGuard = require(script:WaitForChild("ScopeGuard") :: ModuleScript),
}

return table.freeze(module)
