--!strict
type Middleware = { prev: Middleware?, next: Middleware?, fn: (info: any) -> boolean }

local function createStartingMiddleware(fn): Middleware
	return { fn = fn }
end

local function appendMiddlewareTo(parent: Middleware, fn): Middleware
	local myMiddleware = { prev = parent, fn = fn }
	parent.next = myMiddleware
    return myMiddleware
end

local function removeMiddleware(middleware: Middleware)
	local previous = middleware.prev
	local next = middleware.next

	if previous then
		previous.next = next
	end

	if next then
		next.prev = previous
	end
end

local function execute(startingNode: Middleware?, ...)
	local currentMiddleware: Middleware? = startingNode

	while currentMiddleware do
		if not currentMiddleware.fn(...) then
			return false
		end

		currentMiddleware = currentMiddleware.next
	end
    return true
end

return {
    createStartingMiddleware = createStartingMiddleware,
    appendMiddlewareTo = appendMiddlewareTo,
    removeMiddleware = removeMiddleware,
    execute = execute,
}