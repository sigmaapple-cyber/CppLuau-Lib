--!strict

local module = {
	class = require(script:WaitForChild("class") :: ModuleScript),
	struct = require(script:WaitForChild("struct") :: ModuleScript),
	enum = require(script:WaitForChild("enum") :: ModuleScript),
	interface = require(script:WaitForChild("interface") :: ModuleScript),
	namespace = require(script:WaitForChild("namespace") :: ModuleScript),
}

return table.freeze(module)
