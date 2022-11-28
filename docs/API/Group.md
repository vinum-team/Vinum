# Group

The object responsible for state centralization.
____

```lua
function Group(
    setProcessor: (keyName: string, oldKeyValue: unknown, keyValue: unknown)
): Group
```

Constructs and returns a new Group object.
_____

# Parameters

* `setProcessor: (keyName: string, oldKeyValue: unknown, keyValue: unknown) -> (boolean)`
    * The function that `Group` uses to determine whether to pass updates or not. `true` will pass while `false` will dismiss.
___

# Object Methods

### setKey()

```lua
function Group:setKey(keyName: string, keyValue: any)
```

Stores `keyValue` in an internal storage with key as `keyValue`, and starts the dependency management if it hasn't already - additionally, updates all dependents if there are.

Additionally, fires all connections that were connected by `Group:onChange`.

### getKey()

```lua
function Group:getKey(keyName: string): any
```

Returns the current saved value that is attached to the given keyName.

### asState()

```lua
function Group:asState(keyName: string)
```

Returns a table that emulates a self-containing state object. Useful for integration between centralized state and self-containing one.

### onChange()

```lua
function Group:onChange(
    fn: (keyName: string, oldValue: unknown, keyValue: unknown) -> ()
)
```
Connects a function to be fired when a key has been set()'ed - useful when you don't want to use `group:asState` and `observes`.

____

# Example Usage

```lua
local LevelsGroup = Group(Vinum.JustOk)

LevelsGroup:setKey(100, "Fighter")
print(LevelsGroup:getKey(100)) -- Fighter

LevelsGroup:onChange(function(key, oldValue, newValue)
    print(key, oldValue, newValue)
end)
```