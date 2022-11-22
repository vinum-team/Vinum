# Vinum
Vinum is a modern & multi-paradigm reactive state management library intended for powerful use and efficiency.

Vinum currently isn't ready for any production use. 

## Why

Most of the time, we often need proper state management for our code and libraries like rodux are incredibly bloated, and some libraries like Fusion aren't as strict - on top of that, they are relatively slow.

Vinum is a solution that provides proper strictness & speed without a cost on readability - it achieves by optimizing the dependency tree itself, and rather depending on an algorithm to check what dependent to update, it keeps track of dependencies and dependents of an object in a specialized & internal object known as `graph` that provides various functions to further optimize. 

In addition, further optimizations are still possible and would probably be added at some time.

Beside speed, Vinum has a clear and lovely interface to it's internal `graph`ing system, while providing the ability to do whatever you want before an update occurs *(either cancel it or do some cleanup code)*.

*example.luau*
```lua
local root = Hold(100, function(oldValue, newValue)
    if type(newValue) == "number" then
        return true
    else
        return false
    end
end)
local state = Calc(function(useState)
    return useState(root) * 200
end, Vinum.JustOk)

print(state:get()) -- 200

root:set(200)
print(state:get()) -- 400
```

## Goals

* Strict and proper update processing - In Vinum, you have a respectable amount of control whether you want updates to pass through or not
* Speed, but not at the cost of Readability - We love fast-performing code, but we also want our code to be understandable!
* No magic please - We don't love our code have "magic"y functions that can alter the outcome of our updates! *(thats why updateProcessors can't alter the output!)*
