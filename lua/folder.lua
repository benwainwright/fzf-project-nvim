local assert = require("luassert")
local utils = require("utils")

local Folder = {}
Folder.__index = Folder

function Folder:new(params)
	utils.check_variable_type("params", params, "table")
	utils.check_variable_type("params.command", params.command, "string")
	utils.check_variable_type("params.path", params.path, "string")

	local folder = setmetatable({ path = params.path, command = params.command }, Folder)
	return folder
end

local function runCommand(command)
	local handle = io.popen(command)
	if handle then
		local result = handle:read("*a")
		handle:close()
		return result
	end
end

function Folder:items()
	local commandToRun = self.command .. self.path
	local result = runCommand(commandToRun)
	return result
end

return Folder
