local cwd = process.cwd:sub(5)

process.spawn("stylua", {cwd})
local result = process.spawn("selene", {cwd})

print(result.stdout)