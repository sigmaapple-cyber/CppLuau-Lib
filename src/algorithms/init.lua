--!strict

local module = {
	search = require(script:WaitForChild("search") :: ModuleScript),
	sort = require(script:WaitForChild("sort") :: ModuleScript),
	sequence = require(script:WaitForChild("sequence") :: ModuleScript),
	heap = require(script:WaitForChild("heap") :: ModuleScript),
}

return table.freeze(module)
