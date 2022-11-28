# Grouping State

Sometimes, we don't want our state to be duplicated across multiple DataModel, and rather have it centralized in a single place for easy synced management. Vinum allows you to use this paradigm through its `Group` object.

In order to use it, we first need to import its constructor:
```lua
local Group = Vinum.Group
```

And to create a group object, we first need to feed its constructor a ***set***Processor that will act as the middleware:

```lua
local LevelTags = Group(function(KeyName, oldKeyValue, KeyValue)
    return true
end)
```

??? Warning "About oldKeyValue"
    Similar to both Match & Calc, if the key isn't already there, `oldKeyValue` will be `{type = "Symbol", value "None"}`, so account for that in your group-specific processors.` 

To set a key to a value in a group, use its `LevelTags:setKey(keyName, keyValue)` method.

```lua
LevelTags:setKey(100, "Fighter")
LevelTags:setKey(300, "Protector")
```

To get a value using a key in `LevelTags`, we use its `LevelTags:getKey(keyName)` method:
```lua
print(LevelTags:getKey(100)) -- Fighter
```

Groups as well have a built-in utility for listening to changes that occur in a group:

```lua
LevelTags:onChange(function(keyName, oldKeyValue, newKeyValue)
    print(keyName, oldKeyValue, newKeyValue)
end)
```

Additionally, `Group`s come packaged with a method that turns a key-value into a self-contained state object, that is `group:asState(keyName)`, which then can be used for powerful integration with other objects.

```lua
local LEVEL_100_Tag = LevelTags:asState(100)

Observe(LEVEL_100_Tag, Vinum.JustOk):onChange(function()
    print("yes")
end) 
```

Additionally, to use groups in Calc's or Match's handler, we can use the provided `useKeyState(keyName)`:

```lua
local exampleCalc = Calc(function(_, useKeyState)
    return useKeyState(LevelTags, 100)
end, Vinum.JustOk)
```
____

# Why Centralization?

State Centralization is a very respectable state management paradigm as it avoids state being duplicated in multiple DataModels.

Unlike Rodux- which follows State centralization very strictly, Vinum rather gives you the tools to manage centralized state, but doesn't mostly care about how you approach it.

Outside of this complex state management world, you have actually used state centralization in your games in a form of another - for example, using Roblox Attributes to centralize custom state about an object that is readable/writable by other pieces of code.

State centralization also means that we have a single source of truth for ***something***, not necessarily the whole Application's state, but rather a part of it. SSOT is important as it guarantees that we don't have multiple places that have duplicated state, such as a players health - additionally, it is better for memory-wise as well.