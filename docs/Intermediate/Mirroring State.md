---
sidebar_position: 2
---

# Mirroring State

Sometimes, we want to directly return state object's value in all cases, and while Matches are a decent tool for that, Vinum offers a more specialized tool for that, which is `Mirror`.

```lua
local root = Hold(100, Vinum.AlwaysTrue)
local Mirrored = Mirror(root, {
    [100] = Hold("Fighter", Vinum.AlwaysTrue),
    [200] = Hold("Lord", Vinum.AlwaysTrue),
    ["default"] = Hold("Solider", Vinum.AlwaysTrue)
})
```

## Usage

In order to use Mirrors, we first have to import its constructor:
```lua
local Mirror = Vinum.Mirror
```
And now to create a Mirror object, we pass the constructor an input state, and a list of cases:
```lua
local root = Hold(100, Vinum.AlwaysTrue)
local Mirrored = Mirror(root, {
    [100] = Hold("Fighter", Vinum.AlwaysTrue),
    [200] = Hold("Lord", Vinum.AlwaysTrue),
    ["default"] = Hold("Solider", Vinum.AlwaysTrue)
})
```

:::info
Mirrors don't accept Processors because they are expected to be always mirroring a state object's value.
:::

And now, to read from it, we use its `get` method:
```lua
print(Mirrored:get()) -- "Fighter"
```
_____

## Why not a Match
Sometimes, you would often use Matches as a way to return certain state object's value depending on another input state's value, something like this:
```lua
local Matched = Match(root, {
    [100] = function(useState)
        return useState(x)
    end,
    ["default"] = function(useState)
        return useState(b)
    end
}, Vinum.AlwaysTrue)
```

However, there is a lot of boilerplate code, most notably the functions and the retuns, so, as a fix, Mirrors directly accept state objects instead- a mirror-based implementation can look like this:
```lua
local mirrored = Mirror(root, {
    [100] = x,
    ["default"] = b
}
```