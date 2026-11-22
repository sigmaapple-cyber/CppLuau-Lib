--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Result = CppLuau.Values.Result

return function()
	describe("Values.Result", function()
		it("unwraps successes and errors", function()
			expect(Result.Ok(25):Unwrap()).to.equal(25)
			expect(Result.Err("Missing"):UnwrapErr()).to.equal("Missing")
		end)

		it("maps success and error values", function()
			expect(Result.Ok(5)
				:Map(function(value)
					return value * 3
				end)
				:Unwrap()).to.equal(15)

			expect(Result.Err("bad"):MapErr(string.upper):UnwrapErr()).to.equal("BAD")
		end)

		it("preserves errors through Map", function()
			local result = Result.Err("Bad input"):Map(function(value)
				return value
			end)

			expect(result:IsErr()).to.equal(true)
			expect(result:UnwrapErr()).to.equal("Bad input")
		end)
	end)
end
