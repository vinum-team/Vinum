# Match

The object responsible for performing multiple computation depending on an `inputState`'s value.
____

```lua
function Match(
    inputState: anyStateObject,
    cases: { [any]: (useState, useKey) -> ()},
	updateProcessor: (oldValue: any, newValue: any) -> (boolean)
)
```
____

# Parameters

* `inputState: anyStateObject`
    * The state object that we will match
* `cases: { [any]: (useState, useKey) -> ()}`
    * A list of cases that `Match` will treat as multiple `Calcs` that can have their own dependencies.
* `updateProcessor: (oldValue: any, newValue: any) -> (boolean)`
    * The function `Match` uses to determine whether to let updates pass or not.
_____-
# Object Methods

### get()

```lua
function Match:get(): any
```

Returns the current value that is produced by the current case.
____

# Example Usage

```lua
local root = Hold(23, Vinum.JustOk)
local matcher = Match(root, {
    [23] = function(useState, useKeyState)
        return "hi"
    end,
    ["default"] = function(useState, useKeyState)
        return "notFound"
    end,
})

print(matcher:get()) -- hi
```