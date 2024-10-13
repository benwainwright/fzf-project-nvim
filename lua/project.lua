local Folder = require("folder")
local Project = setmetatable({}, {__index = Folder})

function Project:new(params)
    local instance = Folder.new(self, params)
    setmetatable(instance, self)
    self.__index = self
    return instance
end

return Project
