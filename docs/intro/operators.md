# Operating on Data
Vinum provides many operator that help you perform many operations, from something as simple as reading, to something complex as managing async tasks.
::: details Performance Details

Some of the following Operators are inlineable by Luau's level two Complier optimizations, which means operation calls are fast.
:::

## Reading using `Read`
`Read` is an `inlineable` Operator that retreives the value of a `ReactiveObject` or a `refState` (created by [Refs](/intro/ref)). 
```lua
local Read = Vinum.Read
local scope = Vinum.Scoped()

local x = scope:Source(100)

print(Read(x)) -- prints '100'
```

::: warning Performance Reliant on [Conditional Value Caching](/internal/conditional-caching)
:::

## Writing using `Write`
`Write` is an `inlineable` Operator the sets the value of a `ReactiveObject`.
```lua
local Read = Vinum.Read
local Write = Vinum.Write
local scope = Vinum.Scoped()

local x = scope:Source(100)
Write(x, 200)

print(Read(x)) -- prints '200'
```
## Tracking Changes using `Track`
`Track` is an `inlineable` Operator that allows you to run callbacks when a `ReactiveObject`/`refState` updates.
```lua
local Read = Vinum.Read
local Write = Vinum.Write
local Track = Vinum.Track
local scope = Vinum.Scoped()

local x = scope:Source(100)

Track(x, function()
    print("Hi, x was changed!")
end)

Write(x, 200) 

-- "Hi, x was changed!" was printed.
```

Additionally, it returns an `untrack` function that allows you to disable the tracking:
```lua{12}
local Read = Vinum.Read
local Write = Vinum.Write
local Track = Vinum.Track
local scope = Vinum.Scoped()

local x = scope:Source(100)

local untrack = Track(x, function()
    print("Hi, x was changed!")
end)

untrack()

Write(x, 200) 

-- nothing was printed.
```
## Using Dependencies using `Use`
`Use` is an `inlineable` Operator that adds a `ReactiveObject` as an dependent to another `ReactiveObject`/`refState`. More commonly used within `Deriveds`:
```lua
local Read = Vinum.Read
local Write = Vinum.Write
local Use = Vinum.Use
local scope = Vinum.Scoped()

local x = scope:Source(100)
local y = scope:Derived(function(self)
    return Use(self, x) / 2
end)

Write(x, 200)
print(Read(y)) -- "100" is printed.
```
::: warning Performance Reliant on [Conditional Value Caching](/internal/conditional-caching)
:::
::: danger `Use` dependencies aren't persistent!

Vinum automatically recaptures all dependents in every update, as such, dependencies aren't stable and need to be re-added every update. Due to this, you are advised to use `Use` only in `Derived` callbacks.
:::

## Managing Memory For ReactiveObjects using `InnerScope`
## Batching Write Requests using `Batch`
## Running ReactiveObject-dependent Async Tasks using `Async`