--!strict

local module = {
	optional = require(script:WaitForChild("optional") :: ModuleScript),
	result = require(script:WaitForChild("result") :: ModuleScript),
	pair = require(script:WaitForChild("pair") :: ModuleScript),
	tuple = require(script:WaitForChild("tuple") :: ModuleScript),
	variant = require(script:WaitForChild("variant") :: ModuleScript),
	reference = require(script:WaitForChild("reference") :: ModuleScript),
}

return table.freeze(module)
