--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)
local utf8 = luapp.text.utf8

return function()
	describe("text.utf8", function()
		it("counts characters separately from bytes", function()
			local value = "A✓é"

			expect(utf8.Length(value)).to.equal(3)
			expect(#value).to.equal(6)
			expect(utf8.ByteOffset(value, 2)).to.equal(2)
		end)

		it("slices by character positions", function()
			expect(utf8.Sub("A✓éZ", 2, 3)).to.equal("✓é")
			expect(utf8.Sub("A✓éZ", 3)).to.equal("éZ")
		end)

		it("returns codepoints and validates malformed input", function()
			local values = utf8.Codepoints("A✓")
			expect(values[1]).to.equal(65)
			expect(values[2]).to.equal(10003)
			expect(utf8.IsValid(string.char(255))).to.equal(false)
		end)
	end)
end
