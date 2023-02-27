--!strict
local Processors = script.Parent
local LibraryRoot = Processors.Parent
local clean = require(LibraryRoot.Utils.clean)

local function cleanup(_, old, _, _)
    return clean(old)
end

return cleanup