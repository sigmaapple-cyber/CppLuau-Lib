--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Optional = CppLuau.Values.Optional

return function()
	describe("Values.Optional", function()
		it("stores and unwraps values", function()
			local value = Optional.Some(12)

			expect(value:IsSome()).to.equal(true)
			expect(value:Unwrap()).to.equal(12)
			expect(Optional.None():UnwrapOr(5)).to.equal(5)
		end)

		it("maps and chains present values", function()
			local value = Optional.Some(4)
				:Map(function(number)
					return number * 2
				end)
				:AndThen(function(number)
					return Optional.Some(number + 1)
				end)

			expect(value:Unwrap()).to.equal(9)
		end)

		it("preserves empty values", function()
			expect(Optional.None()
				:Map(function(value)
					return value
				end)
				:IsNone()).to.equal(true)
		end)
	end)
end
