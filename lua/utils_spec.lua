local utils = require("utils")
local assert = require("luassert")

describe("utils", function()
	describe("map", function()
		it("applies function to each element in the array", function()
			local input = { 1, 2, 3 }
			local expected = { 2, 4, 6 }
			local function double(x)
				return x * 2
			end
			local result = utils.map(input, double)
			assert.are.same(expected, result)
		end)

		it("handles empty array", function()
			local input = {}
			local expected = {}
			local function double(x)
				return x * 2
			end
			local result = utils.map(input, double)
			assert.are.same(expected, result)
		end)

		it("does not modify the original array", function()
			local input = { 1, 2, 3 }
			local input_copy = { 1, 2, 3 }
			local function noop(x)
				return x
			end
			utils.map(input, noop)
			assert.are.same(input_copy, input)
		end)
	end)

	describe("check_variable_type", function()
		it("does not raise an error if type matches", function()
			assert.has_no.errors(function()
				utils.check_variable_type("numberVar", 123, "number")
			end)
		end)

		it("raises an error if type does not match", function()
			assert.has_error(function()
				utils.check_variable_type("stringVar", 123, "string")
			end, "'stringVar' should have type 'string'")
		end)
	end)
end)
