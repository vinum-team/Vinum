local function stringifyResult(benchmarkDir: {}, space)
    local finalString = ""

    for name, content in benchmarkDir do
        local partString = "\n"..space.."[+] "..name

        if content._50PERCENTILE then
            partString ..= ("."):rep(30 - #name).." "..content._50PERCENTILE
        else
            partString ..= stringifyResult(content, space.." ")
        end

        finalString ..= partString
    end

    return finalString
end

return stringifyResult