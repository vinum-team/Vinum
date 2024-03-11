--!strict
local MiddlewareUtils = require(script.Parent.Parent.Internal.MiddlewareUtils)
local GlobalMiddleware = require(script.Parent.Parent.Utility.GlobalMiddleware)

local function UseMiddleware(operation: "read" | "write" | "recompute", fn)
	local createdMiddleware
	if GlobalMiddleware[operation] then
		createdMiddleware = MiddlewareUtils.appendMiddlewareTo(GlobalMiddleware[operation], fn)
	else
		createdMiddleware = MiddlewareUtils.createStartingMiddleware(fn)
		GlobalMiddleware[operation] = createdMiddleware
	end

	return function()
		MiddlewareUtils.removeMiddleware(createdMiddleware)
	end
end

return UseMiddleware
