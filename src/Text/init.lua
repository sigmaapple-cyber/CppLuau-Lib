--!strict
--[[
	String types, formatting, and text construction.
]]

local module = {
	String = require(script:WaitForChild("String") :: ModuleScript),
	StringBuilder = require(script:WaitForChild("StringBuilder") :: ModuleScript),
	StringView = require(script:WaitForChild("StringView") :: ModuleScript),
	Format = require(script:WaitForChild("Format") :: ModuleScript),
}

return table.freeze(module)
