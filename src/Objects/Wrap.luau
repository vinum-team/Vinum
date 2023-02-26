--!strict
local LibraryRoot = script.Parent.Parent
local Utils = LibraryRoot.Utils
local Processors = LibraryRoot.Processors
local AlwaysTrue = require(Processors.alwaysTrue)
local PubTypes = require(LibraryRoot.pubTypes)
local Types = require(LibraryRoot.types)
local Grapher = require(Utils.grapher)
local create = Grapher.create
local update = Grapher.updateGraph
local updateDependents = Grapher.updateDependents
local Read = require(Utils.read)
local class: PubTypes.Wrap<unknown, unknown> = { type = "state", kind = "wrap", behavior = "central" } :: any
local meta = { __index = class }

function class:_update()
    local currentEvent = Read(self._event)

    if self._currentEvent ~= currentEvent then
        if self._eventConnection then
            self._eventConnection:Disconnect()
        end

        self._eventConnection =  currentEvent:Connect(function(...)
            self._values = {self._handler(self._values, {...})}
        end)

        self._currentEvent = currentEvent
    end
	return true, false
end

function class:_setValue(key, newValue)
	if not self._processor(key, self._values[key], newValue, false) then
		return false
	end

	self._values[key] = newValue
	updateDependents(self._graphs[key])
	return true
end

return function<T>(
	event: Types.CanBeState<RBXScriptSignal>,
	initialValue: { T },
	handler: (oldValues: { T }, newValues: { T }) -> ...T,
	processor: Types.TProcessor<T>
)
	local self = (
		setmetatable({
			_processor = AlwaysTrue,
			_event = event,
			_handler = handler,
			_values = initialValue,
			_graphs = table.create(#initialValue),
			_static = true,
		}, meta) :: any
	) :: PubTypes.Wrap<any, any>

	local graphs = self._graphs :: any
	local myGraph
	for i in initialValue do
		if i == 1 then
			myGraph = create(self)
			table.insert(graphs, myGraph)
		else
			local graph = create()
			graph.dependencySet[myGraph] = true
			myGraph.dependentSet[graph] = true
			table.insert(graphs, graph)
		end
	end

	if type(event) == "table" then
		local eventGraph = (event::any)._graph
		eventGraph.dependentSet[myGraph] = true
		myGraph.dependencySet[eventGraph] = true
	end

	update(myGraph)
	self._processor = processor or AlwaysTrue
	return self
end
