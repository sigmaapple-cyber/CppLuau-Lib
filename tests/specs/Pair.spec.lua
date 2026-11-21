--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Pair = CppLuau.Pair

return function()
	describe("Pair", function()
		it("stores and unpacks two values", function()
			local pair = Pair.new("left", "right")
			local first, second = pair:Unpack()

			expect(first).to.equal("left")
			expect(second).to.equal("right")
		end)

		it("swaps values", function()
			local first, second = Pair.new(1, 2):Swap():Unpack()

			expect(first).to.equal(2)
			expect(second).to.equal(1)
		end)

		it("maps both values", function()
			local first, second = Pair.new(2, 3)
				:Map(function(a, b)
					return a * 2, b * 3
				end)
				:Unpack()

			expect(first).to.equal(4)
			expect(second).to.equal(9)
		end)
	end)
end
