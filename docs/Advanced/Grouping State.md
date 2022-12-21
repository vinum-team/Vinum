---
sidebar_position: 2
---
# Grouping State
Centralizing your state is sometimes a necessary evil. Learn how Vinum helps you manage centralized state using `Groups`.

## Usage
To use Groups, we first must import its constructor:
```lua
local Group = Vinum.Group
```

And now to create a Group, we pass a set processor that will be fired with the key name, and the old value, and the new value:
```lua
local props = Group(function(key, oldvalue, newvalue)
    return true
end)
```

And now to write to it, we fire its `setKey`:
```lua
props:setKey("yourKey", 123)
```

And now, to read from it, we use its `getKey`:
```lua
print(props:getKey("yourKey")) -- 123
```

Aside from basic reading/writing operations, we can **also** directly connect connections that will run once a change has been made:
```lua
props:onChange(function(key, oldValue, newValue)
    print(key, oldValue, newValue)
end)
```
And aside from all of that basic operations, ***we can also create self-contained copies of a group key!*** To do this, we use its `asState` method which we can read from using its `get` method as well:
```lua
local yourKey = props:asState("yourKey")
print(yourKey:get())
```
_____
## Why Centralization?
State Centralization is a very respectable state management paradigm as it avoids state being duplicated in multiple DataModels.

Unlike Rodux- which follows State centralization very strictly, Vinum rather gives you the tools to manage centralized state, but doesn't mostly care about how you approach it.

Outside of this complex state management world, you have actually used state centralization in your games in a form of another - for example, using Roblox Attributes to centralize custom state about an object that is readable/writable by other pieces of code.

State centralization also means that we have a single source of truth for ***something***, not necessarily the whole Application's state, but rather a part of it. SSOT is important as it guarantees that we don't have multiple places that have duplicated state, such as a players health - additionally, it is better for memory-wise as well.

## Injectors: useKeyState
In the Calc/Match docs, you saw a weird injector that goes by the name of useKeyState. This injector is simply a function that allows you to depend on specific keys within a group, like this:

```lua
local CalcObj = Calc(function(_, useKeyState)
    return useKeyState(groupHere, "anyKey")
end, AlwaysTrue)
```
This now will trigger an update whenever anyKey is changed.