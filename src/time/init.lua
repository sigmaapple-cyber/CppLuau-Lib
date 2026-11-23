--!strict

local module = {
	clock = require(script:WaitForChild("clock") :: ModuleScript),
	duration = require(script:WaitForChild("duration") :: ModuleScript),
	timer = require(script:WaitForChild("timer") :: ModuleScript),
}

return table.freeze(module)
