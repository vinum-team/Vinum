# Observe

The object responsible for managing connections that run when a state object updates.

___

```lua
function Observe(
    state: anyStateObject,
    updateProcessor: (newValue: any) -> (boolean)    
): Observe
```

Constructs and returns a new Observe object.
___

# Parameters

* `state: anyStateObject`
    * The state object we will listen to changes coming from
* `updateProcessor: (newValue: any) -> (boolean)`
    * The function `Observe` uses to determine whether to fire its connections or not.
____

# Object Methods

### onChange()
```lua
function Observe:onChange(fn: (newValue: any) -> ()): disconnectorFunc
```

Adds `fn` as a connection, and then return a function that removes the connection.

___

# Example Usage

```lua

local health = Hold(100, Vinum.JustOk)
local HealthObserver = Observe(health, Vinum.JustOk)

HealthObserver:onChange(function(newValue)
    print(newValue)
end)
```EWeS