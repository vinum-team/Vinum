---
sidebar_position: 3
---

# Recording State

Sometimes, we need to store "versions" of certian state objects for stuff like undo/redo changes for states- Vinum allows you to do this using `Records`.
```lua
local holder = Hold(100, Vinum.AlwaysTrue)
local recorder = Record(holder, true)

print(recorder:get()) -- 100
recorder:desync()
holder:set(40)
print(recorder:get()) -- 100 since the recorder object is desynced
```

## Usage

To use Record, we first import its constructor:
```lua
local Record = Vinum.Record
```

And to create a record, we pass our input state, and a boolean that indicate whether our record object is initally synced or not:
```lua
local holder = Hold(100, Vinum.AlwaysTrue)
local recorder = Record(holder, true)
```

And now to read from our recorder, we use its `get` method:
```lua
print(recorder:get()) -- 100
```

Additionally, we can desync our recorder, which will stop listening to updates coming from `holder`, using `desync`:
```lua
recorder:desync()
holder:set(40)
print(recorder:get()) -- 100
```

After that, we can sync our recorder once again:
```lua
recorder:sync()
print(recorder:get()) -- 40
```
_____

## Why Record States

Records are more specialist than other object; their only purpose is to allow you to create 'versions" of a specific state object very efficiently.

`Verions` though aren't really tied to any "paradigm", in fact, it can also help you create "frozen" versions of another state objects- so maybe you want to implement a delay in how a certain process receives your state, something like this:
```lua
local Value = Hold(1, AlwaysTrue)
local RecordedValue = Record(Value, false)
Observe(RecordedValue, AlwaysTrue):onChange(function(newValue)
    print(newValue)
end)

task.spawn(function()
    while true do
        RecordedValue:sync()
        RecordedValue:desync()
        task.wait(1)
    end
end)

Value:set(2)
Value:set(3)
Value:set(4) -- This will print last
```
This example is pretty simple, and its behavior can be simplified down to:
1. We initialize an observer- we treat this as the "consumer" point.
2.  We spawn a new task, and then create a loop that runs every second *(which represents a frame)*- where we sync and desync the RecordedValue.
2. Finallly, we set `Value` to another value for three times- which if you tried running this code, you will notice that `4` is printed.