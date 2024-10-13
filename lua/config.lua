local Workspace = require('workspace')
local inspect = require('inspect')
local utils = require("utils")

local Config = {}
Config.__index = Config

function Config:new() return setmetatable({}, Config) end

function Config:get_project_config()
    if self.rawConfig == nil then
        local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE")
        local configLines = vim.fn.readFile(home_dir .. ".neovim-projects.json")
        local jsonString = table.concat(configLines, "\n")
        self.rawConfig = vim.fn.json_decode(jsonString)
    end
    return self.rawConfig
end

function Config:workspaces()
    local config = self:get_project_config()
    return utils.map(config.workspaces, function(workspace)
        local w = Workspace:new({path = workspace})
        return w
    end)
end

return Config
