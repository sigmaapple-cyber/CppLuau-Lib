--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Optional = CppLuau.Optional

return function()
	describe("Optional", function()
		it("stores and unwraps a value", function()
			local value = Optional.Some(12)

			expect(value:IsSome()).to.equal(true)
			expect(value:Unwrap()).to.equal(12)
		end)

		it("returns a fallback for an empty value", function()
			local value = Optional.None()

			expect(value:IsNone()).to.equal(true)
			expect(value:UnwrapOr(5)).to.equal(5)
		end)

		it("maps present values", function()
			local value = Optional.Some(4):Map(function(number)
				return number * 2
			end)

			expect(value:Unwrap()).to.equal(8)
		end)

		it("preserves empty values when mapping", function()
			expect(Optional.None()
				:Map(function(value)
					return value
				end)
				:IsNone()).to.equal(true)
		end)

		it("chains optional operations", function()
			local value = Optional.Some(3):AndThen(function(number)
				return Optional.Some(number + 4)
			end)

			expect(value:Unwrap()).to.equal(7)
		end)
	end)
end
