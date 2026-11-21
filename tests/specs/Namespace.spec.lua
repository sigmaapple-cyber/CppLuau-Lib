--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Namespace = CppLuau.Namespace

return function()
	describe("Namespace", function()
		it("defines, reads, and removes values", function()
			local std = Namespace.new("std")

			std:Define("Version", 1)
			expect(std:Get("Version")).to.equal(1)
			expect(std:Has("Version")).to.equal(true)
			expect(std:Remove("Version")).to.equal(true)
			expect(std:Has("Version")).to.equal(false)
		end)

		it("creates and reuses child namespaces", function()
			local std = Namespace.new("std")
			local containers = std:Child("containers")

			expect(containers.Name).to.equal("std.containers")
			expect(std:Child("containers")).to.equal(containers)
		end)

		it("exports a frozen copy", function()
			local std = Namespace.new("std")
			std:Define("Version", 1)

			local exported = std:Export()

			expect(exported.Version).to.equal(1)
			expect(table.isfrozen(exported)).to.equal(true)
		end)
	end)
end
