--!strict

local module = {
	string = require(script:WaitForChild("string") :: ModuleScript),
	stringBuilder = require(script:WaitForChild("stringBuilder") :: ModuleScript),
	stringView = require(script:WaitForChild("stringView") :: ModuleScript),
	format = require(script:WaitForChild("format") :: ModuleScript),
	utf8 = require(script:WaitForChild("utf8") :: ModuleScript),
}

return table.freeze(module)
