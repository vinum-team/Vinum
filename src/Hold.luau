local graph = require(script.Parent.utils.graph)

--[=[
	@class Hold

	```lua
	function Hold<T>(
		initialValue: T, -- The value that will be stored initially.
		updateProcessor: ( -- The function that will be used to determine whether to pass updates or not.
			oldValue, 
			newValue
		) -> (boolean)
	)
	```

	Constructs a new Hold Object, which is used to store singular values. 

	:::caution
	Passing a nil for `initialValue` is considered unsafe and can cause unintended behavior.
	:::

	____

	In Vinum, one of the ways to store singular, independent state is through
	Holds. 

	## Usage
	
	In order to use `Hold`, we can either directly reference it from the `Vinum` table, or 
	import it like so:
	```lua
	local Hold = Vinum.Hold
	```

	To create a Hold object, we pass an initial value, and a Processor- though for now, you only need to understand
	that Processors are just pure functions that return booleans that determine whether to let an update go or not.

	Generally speaking; with Holds, we usually need our code to not launch updates then the new value is the same. To do this, we can use the `IsDifferent` processor- this is a
	processor that returns true if both the old value and the new value are different.

	To use this processor, we can import it like:
	```lua
	local isDifferent = Vinum.Processors.isDifferent
	```

	Now, we can fully create our Hold object like the following:
	```lua
	local holder = Hold(100, isDifferent)
	```

	To learn more about Processors, go to the `Processors` page on the left.

	### Reading

	In order to read our Holds' values, we use the `read` standard function.

	To import it, do the following:
	```lua
	local read = Vinum.read
	```

	Now, to read from our previously-created `holder`, we do:
	```lua
	print(read(holder)) -- 100
	```

	### Writing

	In order to read our Holds
]=]
local class = { type = "state", kind = "hold" }
local meta = { __index = class }


function class:_getValue()
	return self._value
end

function class:_setValue(newValue)
	if not self._updateProcessor(self._value, newValue) then
		return
	end

	self._value = newValue

	self._graph:updateDependents()
end

local function Hold<T>(initialValue: T, updateProcessor: (T, T) -> (boolean))
	local self = setmetatable({
		_isSelfContained = true,
		_value = initialValue,
		_updateProcessor = updateProcessor,
		_graph = {},
	}, meta)

	self._graph = graph(self)

	return self
end

return Hold
