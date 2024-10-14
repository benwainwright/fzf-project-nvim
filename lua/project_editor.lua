local ProjectEditor = {}
local n = require("nui-components")
local utils = require("utils")

ProjectEditor.__index = ProjectEditor

function ProjectEditor:new(params)
	local project_editor = setmetatable({ config = params.config }, ProjectEditor)

	project_editor.renderer = n.create_renderer({
		width = 60,
		height = 4,
	})
end

function ProjectEditor:show()
	local workspaces = utils.map(self.config:workspaces(), function(workspace)
		return n.option(workspace.name, { id = workspace.name })
	end)
	local workspaces_select = n.select(workspaces)

	local box = n.box(1)

	local editor = n.box({ flex = 2, direction = "row" }, { workspaces_select, box })
	self.renderer:render(editor)
end
