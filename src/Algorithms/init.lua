--!strict
--[[
	Search, sorting, and sequence algorithms.
]]

local module = {
	Search = require(script:WaitForChild("Search") :: ModuleScript),
	Sort = require(script:WaitForChild("Sort") :: ModuleScript),
	Sequence = require(script:WaitForChild("Sequence") :: ModuleScript),
}

return table.freeze(module)
