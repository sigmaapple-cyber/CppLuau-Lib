--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

return function()
	describe("Text.Format", function()
		it("formats positional fields and pads strings", function()
			local Format = CppLuau.Text.Format

			expect(Format.Template("{0} scored {1}", "Alex", 10)).to.equal("Alex scored 10")
			expect(Format.PadLeft("7", 3, "0")).to.equal("007")
			expect(Format.PadRight("x", 3, ".")).to.equal("x..")
		end)
	end)

	describe("Text.StringView", function()
		it("slices and searches without losing its source", function()
			local view = CppLuau.Text.StringView.new("CppLuau-Library", 1, 7)

			expect(view:ToString()).to.equal("CppLuau")
			expect(view:Find("Luau")).to.equal(4)
			expect(view:Slice(4, 4):ToString()).to.equal("Luau")
		end)
	end)
end
