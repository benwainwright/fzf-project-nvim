local Folder = require("folder")
local Project = require("project")
local Workspace = setmetatable({}, { __index = Folder })
local utils = require("utils")

local command = "fd"

function Workspace:new(params)
	local instance = Folder.new(self, { path = params.path, command = params.command, name = params.name })
	setmetatable(instance, self)
	self.__index = self
	return instance
end

function Workspace:projects()
	local items = self:items()
	local projects = utils.map(items, function(item)
		return Project:new({ path = item })
	end)

	return projects
end

return Workspace
