--!optimize 2
-- Some parts of this script was taken by Fusion until an actual in house solution for runtime-agnostic benchmarking

local process = require("@lune/process")
local fs = require("@lune/fs")

local function getDescendents(dir, result)
	local contents = fs.readDir(dir)

	for _, name in contents do
		local path = `{dir}/{name}`


		if fs.isDir(path) then
			getDescendents(path, result)
		else
            if not string.find(path, "bench.luau") then
                continue 
            end
			result[path] = `function() {fs.readFile(path)} end`
		end
	end

	return result
end

local rawResult = getDescendents(process.args[1], {})

-- Convert a lua table into a lua syntactically correct string
function table_to_string(tbl)
    local result = '{'
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == 'string' then
            result = result..'[\''..k..'\']'..'='
        end

        -- Check the value type
        if type(v) == 'table' then
            result = result..table_to_string(v)
        elseif type(v) == 'boolean' then
            result = result..tostring(v)
        else
            result = result..v
        end
        result = result..','
    end
    -- Remove leading commas from the result
    if result ~= '' then
        result = result:sub(1, result:len()-1)
    end
    return result..'}'
end

fs.writeFile("testResult.luau", `return {table_to_string(rawResult)}`)