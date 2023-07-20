local process = require("@lune/process")
local fs = require("@lune/fs")
local cwd = process.cwd

local content = fs.readFile("luneTypes.d.luau")
fs.removeFile("luneTypes.d.luau")
local styluaResult = process.spawn("stylua", {cwd})

fs.writeFile("luneTypes.d.luau", content)

local seleneResult = process.spawn("selene", {cwd})

if not styluaResult.ok then
    error(styluaResult.stderr)
end

print(seleneResult.stderr)
print(seleneResult.stdout)