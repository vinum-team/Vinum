local net = require("@lune/net")
local serde = require("@lune/serde")
local process = require("@lune/process")
local fs = require("@lune/fs")

local p = require("commandParser")

local _, args = p(process.args)

local function assert(condition, err)
	if not condition then
		error(err, 2)
	end
end

local version = args.version
local buildMode = args.buildMode

assert(version and buildMode, "Information is missing")

--[[
    local version = processedArgs.version or ""
local sourceCodePath = processedArgs.pathForSourceDir
local buildMode = processedArgs.buildMode
]]

process.spawn("lune", { "build", "==version", version, "==pathForSourceDir", "src", "==buildMode", buildMode })

local cwdSplit = process.cwd:split("\\")
print(`{process.cwd}/{cwdSplit[#cwdSplit-1]}@{version}.rbxm`)
local data = serde.compress("lz4", fs.readFile(`{process.cwd}{cwdSplit[#cwdSplit-1]}@{version}.rbxm`))
print(data)