--!strict

local module = {
	core = require(script:WaitForChild("core") :: ModuleScript),
	values = require(script:WaitForChild("values") :: ModuleScript),
	containers = require(script:WaitForChild("containers") :: ModuleScript),
	algorithms = require(script:WaitForChild("algorithms") :: ModuleScript),
	math = require(script:WaitForChild("math") :: ModuleScript),
	text = require(script:WaitForChild("text") :: ModuleScript),
	utility = require(script:WaitForChild("utility") :: ModuleScript),
	time = require(script:WaitForChild("time") :: ModuleScript),
	binary = require(script:WaitForChild("binary") :: ModuleScript),
}

return table.freeze(module)
