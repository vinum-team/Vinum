local fs = require("@lune/fs")
local CrescTest = require("luneVendor/CrescTest")

local scriptString = [[
	local function PathHolder(currentPath)
		return setmetatable({ path = currentPath }, {
			__index = function(self, index)
				if index then
					if index == "Parent" then
						return PathHolder(`{currentPath}../}`)
					else
						return PathHolder(`{string.gsub(currentPath, "}", "")}{index}/`)
					end
				else
					return self
				end
			end,
		})
	end
	
	local script = setmetatable({ path = "" }, {
		__index = function(self, index)
			if index == "" then
				return script
			end
	
			if index ~= "Parent" then
				return PathHolder(`{index}/`)
			end
	
			if index == "Parent" then
				return PathHolder("")
			end
	
			return script
		end,
	})
]]

local requireScript = [[
    local function requireImpl(thing)
        if type(thing) == "string" then
            return require(string.gsub(thing, "src", "procSrc"))
        end
        return require(thing.path)
    end
]]


local function transformSrc(startingPath: string)
	for _, name in fs.readDir(startingPath) do
		local path = `{startingPath}/{name}`
		if fs.isDir(path) then
			transformSrc(path)
		else
			local content = fs.readFile(path)
			fs.writeFile(
				path,
				`{requireScript} \n {scriptString} \n return (function() \n {string.gsub(content, "require", "requireImpl")} end)()`
			)
		end
	end
end

--[[
    Wrap all source files so that we can inject proxy requires and 
    `script`s
]]
fs.copy("src", "procSrc")
transformSrc("procSrc")

--[[
    Wrap all test files so that we can inject proxy requires
]]

fs.copy("tests", "procTests")
transformSrc("procTests")

local ok, err = pcall(function()
    CrescTest.runLune("procTests", CrescTest.expect)
end)

local function run(path)
	for _, itemName in fs.readDir(path) do
		local itemPath = `{path}/{itemName}`
		if fs.isFile(itemPath) and itemName:find(".luau") then
			require(`../` .. itemPath)
		elseif fs.isDir(itemPath) then
			run(itemPath)
		end
	end
end

fs.copy("benchmarks", "proc-bench")
transformSrc("proc-bench")
run("proc-bench")

if not ok then
    warn(err)
end

fs.removeDir("proc-bench")
fs.removeDir("procSrc")
fs.removeDir("procTests")