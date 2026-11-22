--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Pair = CppLuau.Values.Pair

return function()
	describe("Values.Pair", function()
		it("stores, unpacks, swaps, and maps values", function()
			local first, second = Pair.new(2, 3)
				:Map(function(a, b)
					return a * 2, b * 3
				end)
				:Swap()
				:Unpack()

			expect(first).to.equal(9)
			expect(second).to.equal(4)
		end)
	end)
end
