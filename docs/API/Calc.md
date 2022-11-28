# Calc

The object responsible for dynamic and derived values.
___

```lua
function Calc<T>(
    calculator: (useState, useKeyState) -> (T),
    updateProcessor: (oldValue: T, newValue: T) -> (boolean)
): Calc<T>
```

Constructs and returns a calc object.

_____
# Parameters

* `calculator: (useState, useKeyState) -> (T)`
    * The function `Calc` calls to get the updated value once an update is occured in an dependency.
* `updateProcessor: (oldValue: T, newValue: T) -> (boolean)`
    * The function `Calc` calls to determine whether to pass the current update or not. `false` will reject and `true` will accept.
___

# Object Methods

### get()
```lua
function CalcObj:get() : T
```

Returns the current stored value.

______

# Example Usage

```lua
local DeathsGroup = Group(Vinum.JustOk)
local kills = Hold(100, Vinum.RefuseIfSimilar)

DeathsGroup:setKey("myCurrentDeaths", 200)

local kdRatio = Calc(function(useState, useKeyState)
    return useState(kills) / useKeyState(DeathsGroup, "myCurrentDeaths")
end)

print(kdRatio:get()) -- 0.5
```