--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Result = CppLuau.Result

return function()
	describe("Result", function()
		it("unwraps successful values", function()
			local result = Result.Ok(25)

			expect(result:IsOk()).to.equal(true)
			expect(result:Unwrap()).to.equal(25)
		end)

		it("retains error values", function()
			local result = Result.Err("Missing")

			expect(result:IsErr()).to.equal(true)
			expect(result:UnwrapErr()).to.equal("Missing")
		end)

		it("maps successful values", function()
			local result = Result.Ok(5):Map(function(value)
				return value * 3
			end)

			expect(result:Unwrap()).to.equal(15)
		end)

		it("preserves errors while mapping success", function()
			local result = Result.Err("Bad input"):Map(function(value)
				return value
			end)

			expect(result:IsErr()).to.equal(true)
			expect(result:UnwrapErr()).to.equal("Bad input")
		end)

		it("maps errors", function()
			local result = Result.Err("bad"):MapErr(string.upper)

			expect(result:UnwrapErr()).to.equal("BAD")
		end)

		it("chains successful results", function()
			local result = Result.Ok(2):AndThen(function(value)
				return Result.Ok(value + 8)
			end)

			expect(result:Unwrap()).to.equal(10)
		end)
	end)
end
