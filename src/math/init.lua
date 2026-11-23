--!strict

local module = {
	scalar = require(script:WaitForChild("scalar") :: ModuleScript),
	numeric = require(script:WaitForChild("numeric") :: ModuleScript),
	random = require(script:WaitForChild("random") :: ModuleScript),
	bit = require(script:WaitForChild("bit") :: ModuleScript),
	complex = require(script:WaitForChild("complex") :: ModuleScript),
}

return table.freeze(module)
