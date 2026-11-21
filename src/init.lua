--!strict
--[[
	Public entry point for CppLuau-Lib.
]]

local module = {
	Class = require(script:WaitForChild("Class") :: ModuleScript),
	Struct = require(script:WaitForChild("Struct") :: ModuleScript),
	Enum = require(script:WaitForChild("Enum") :: ModuleScript),
	Interface = require(script:WaitForChild("Interface") :: ModuleScript),
	Namespace = require(script:WaitForChild("Namespace") :: ModuleScript),
	Optional = require(script:WaitForChild("Optional") :: ModuleScript),
	Result = require(script:WaitForChild("Result") :: ModuleScript),
	Pair = require(script:WaitForChild("Pair") :: ModuleScript),
	Tuple = require(script:WaitForChild("Tuple") :: ModuleScript),
	Variant = require(script:WaitForChild("Variant") :: ModuleScript),
	Reference = require(script:WaitForChild("Reference") :: ModuleScript),
	Scope = require(script:WaitForChild("Scope") :: ModuleScript),
	Algorithms = require(script:WaitForChild("Algorithms") :: ModuleScript),
	Numeric = require(script:WaitForChild("Numeric") :: ModuleScript),
	Functional = require(script:WaitForChild("Functional") :: ModuleScript),
	Iterator = require(script:WaitForChild("Iterator") :: ModuleScript),
	String = require(script:WaitForChild("String") :: ModuleScript),
	StringBuilder = require(script:WaitForChild("StringBuilder") :: ModuleScript),
	Math = require(script:WaitForChild("Math") :: ModuleScript),
	Type = require(script:WaitForChild("Type") :: ModuleScript),
	Containers = require(script:WaitForChild("Containers") :: ModuleScript),
}

return table.freeze(module)
