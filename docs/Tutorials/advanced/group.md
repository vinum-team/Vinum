# State Grouping

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
    Similar to both Match & Calc, if the key isn't already there, `oldKeyValue` will be `{type = "Symbol", value "None"}`.