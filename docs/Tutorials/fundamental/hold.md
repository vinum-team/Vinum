# State Holding

You might be scared from the name "State Holding", however, it is really simple! In Vinum, "State Holding" is just saving data into the object `Hold`! But what are `Hold`s? 

They are objects that we can use to store data into, and then read from and write to.

 we first need to require `Hold`'s constructor *(this assumes you already installed Vinum and placed it in ReplicatedStorage)*
```Lua
local Hold = Vinum.Hold
```
Now to create a `Hold`, we have to feed it an initial value *(otherwise it would default ot `{type = "Symbol", value = "None"})* and a Processor that has to be a function that returns a boolean.

```Lua
local Health = Hold(100, function(oldValue, NewValue)
    return true
end)
```
Now, to read that value, we can use `Health:get()`:
```lua
print(Health:get()) -- 100
```
Now to write to it, we can use `Health:set(newValue)`:
```lua
Health:set(50)
print(Health:get()) -- 50
```

By default, Vinum accepts changes that set the same value - this is because Vinum doesn't want to restrict you in any way with how you want to manage your projects to some extent, although you can use `Vinum.RefuseIfSimilar` Processor instead of the function you already passed to implement this.
______

# Why: The Problem

`Hold` object doesn't seem to do much rather than simulating a normal variable, so why not use a variable directly?

The problem here is that luau variables don't change when any of their dependencies *(pieces of data/code we depend on)* change. Take this for example:

```lua
local Health = 100

local midHealth = Health / 2

print(midHealth) -- 50
Health = 50
print(midHealth) -- 50?
``` 

In this example, `midHealth` was actually correct, however, when `Health` changed to 50, `midHealth` remained 50, rather than changing to 25.

So, to cut a long story short, we don't really have a way to sync variables, and in order to solve that, we need objects that exactly do that for us.

# Why: The Fix

The fix is to have simple objects that at least store a list of dependents *(places that depend on us)*, so we know who to notify when there is a change.

Vinum implements this in the form of "graph objects", they are little objects that store a list of dependencies and dependents. They are the objects that are behind all Vinum magic, and in fact `Hold` is just an abstract object that lets you communicate with them.


`Hold` on the other hand, is designed to act as "safe-variable" state object, it has an additional method that is `set()` that lets you change what value it is `Hold`ing - additionally, it uses the processor you gave it to determine whether to change its value and notify its dependents, or not.