# Vusion: [0.2=0.2]: V0.1

Vusion is an ergonomic and efficient binding between Fusion, a UI library, and Vinum, a state management library.

It is the recommended way to use the two libraries together as it is the "standard" solution, and is guaranteed to be updated as Vinum updates.

## Special Key
Vusion is packaged with a special fusion key that allows you to either pass a non-table data type or a vinum state object to bind to.

### Example
```lua
local Vusion = require(path)(Fusion, Vinum)

local tag = Hold("myTagHere", Vinum.AlwaysTrue)

Fusion.New "Part" {
    [Vusion.Key] = {
        Name = Vinum.Calc(function(useState)
            return "part" .. useState(tag)
        end, Vinum.AlwaysTrue),
        Anchored = true
    }
}
```

## Transformer

In addition to a special key, Vusion is equiped with a transformer function that allows for communication between fusion objects *(such as Springs and Tweens)*, and Vinum objects.

### Example

```lua
local Vusion = require(path)(Fusion, Vinum)

local Health = Fusion.Value(100)
local vinumHealth = Vusion.toVinum(Health, true) -- the last boolean determines if the return object is writable or not.

Health:set(40) 
print(vinumHealth:get() == Health:get()) -- true
```
In the previous example, vinumHealth is writable *(therefore is provided with a `set` method)*, however, directly writing to it is discouraged since any changes to `Health` will override `vinumHealth`.

Additionally, transforming Fusion observers isn't supported as it doesn't make sense to do so.

## VSpring and VTween

VSpring and VTween are simply functions that call `toVinum` on a newly created spring/tween object- and the API is identical to the standard Fusion's spring/tween implementation- as such, referring to the Fusion's V0.2 documentation is preferred.