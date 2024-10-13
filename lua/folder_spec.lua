local Folder = require("folder")
local assert = require("luassert")

-- Save the original io.popen function to restore later
local original_popen = io.popen

-- Mock functions to simulate different scenarios
local function mock_popen_success(command)
	local handle = {}
	function handle:read(mode)
		return "mock output"
	end
	function handle:close()
		return true
	end
	return handle
end

local function mock_popen_nil(command)
	return nil
end

local function mock_popen_handle_read_nil(command)
	local handle = {}
	function handle:read(mode)
		return nil
	end
	function handle:close()
		return true
	end
	return handle
end

local function mock_popen_command_not_found(command)
	local handle = {}
	function handle:read(mode)
		return "sh: invalidcommand: command not found\n"
	end
	function handle:close()
		return true
	end
	return handle
end

local function mock_popen_no_output(command)
	local handle = {}
	function handle:read(mode)
		return ""
	end
	function handle:close()
		return true
	end
	return handle
end

describe("Folder class", function()
	-- Restore io.popen after each test to prevent side effects
	after_each(function()
		io.popen = original_popen
	end)

	it("should create a new Folder with valid params", function()
		local params = { path = "/some/path", command = "ls " }
		local folder = Folder:new(params)
		assert.is_not_nil(folder)
		assert.equals("/some/path", folder.path)
		assert.equals("ls ", folder.command)
	end)

	it("should return items with valid command and path", function()
		io.popen = mock_popen_success
		local params = { path = "/some/path", command = "ls " }
		local folder = Folder:new(params)
		local result = folder:items()
		assert.equals("mock output", result)
	end)

	it("should handle when io.popen returns nil", function()
		io.popen = mock_popen_nil
		local params = { path = "/some/path", command = "ls " }
		local folder = Folder:new(params)
		local result = folder:items()
		assert.is_nil(result)
	end)

	it("should handle when handle:read returns nil", function()
		io.popen = mock_popen_handle_read_nil
		local params = { path = "/some/path", command = "ls " }
		local folder = Folder:new(params)
		local result = folder:items()
		assert.is_nil(result)
	end)

	it("should error when command is nil", function()
		local params = { path = "/some/path", command = nil }
		assert.has_error(function()
			Folder:new(params)
		end, "'params.command' should have type 'string'")
	end)

	it("should error when path is nil", function()
		local params = { path = nil, command = "ls " }
		assert.has_error(function()
			Folder:new(params)
		end, "'params.path' should have type 'string'")
	end)

	it("should error when params is nil", function()
		assert.has_error(function()
			Folder:new(nil)
		end, "'params' should have type 'table'")
	end)

	it("should work when command is empty string", function()
		io.popen = mock_popen_success
		local params = { path = "/some/path", command = "" }
		local folder = Folder:new(params)
		local result = folder:items()
		assert.equals("mock output", result)
	end)

	it("should work when path is empty string", function()
		io.popen = mock_popen_success
		local params = { path = "", command = "ls " }
		local folder = Folder:new(params)
		local result = folder:items()
		assert.equals("mock output", result)
	end)

	it("should error when command is a number", function()
		local params = { path = "/some/path", command = 123 }
		assert.has_error(function()
			Folder:new(params)
		end, "'params.command' should have type 'string'")
	end)

	it("should handle when command not found", function()
		io.popen = mock_popen_command_not_found
		local params = { path = "/some/path", command = "invalidcommand " }
		local folder = Folder:new(params)
		local result = folder:items()
		assert.equals("sh: invalidcommand: command not found\n", result)
	end)

	it("should handle when command outputs nothing", function()
		io.popen = mock_popen_no_output
		local params = { path = "/some/path", command = "ls " }
		local folder = Folder:new(params)
		local result = folder:items()
		assert.equals("", result)
	end)
end)
