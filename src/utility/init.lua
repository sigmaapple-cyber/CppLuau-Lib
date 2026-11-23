--!strict

local module = {
	functional = require(script:WaitForChild("functional") :: ModuleScript),
	iterator = require(script:WaitForChild("iterator") :: ModuleScript),
	typeInfo = require(script:WaitForChild("typeInfo") :: ModuleScript),
	scopeGuard = require(script:WaitForChild("scopeGuard") :: ModuleScript),
}

return table.freeze(module)
