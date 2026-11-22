--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

return function()
	describe("Binary.Buffer", function()
		it("writes and reads primitive values", function()
			local data = CppLuau.Binary.Buffer.new(1)

			data:WriteU8(255)
				:WriteI16(-1234)
				:WriteU32(123456)
				:WriteF32(1.5)
				:WriteString("Luau")

			expect(data:Size()).to.equal(15)
			data:Seek(0)

			expect(data:ReadU8()).to.equal(255)
			expect(data:ReadI16()).to.equal(-1234)
			expect(data:ReadU32()).to.equal(123456)
			expect(data:ReadF32()).to.equal(1.5)
			expect(data:ReadString(4)).to.equal("Luau")
		end)

		it("rejects reads past the written length", function()
			local data = CppLuau.Binary.Buffer.new()
			expect(function()
				data:ReadU8()
			end).to.throw()
		end)
	end)
end
