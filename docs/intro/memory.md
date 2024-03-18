# Understanding Memory in Vinum
Memory is such an important concept in Vinum specifically because the way the API is designed. By design, a certain approach to memory management is enforced when working with Vinum, as such, learning how it works is vital to you as a user.

## The Problem
Values in Luau are of two very different types:
* Garbage-collection-safe (gc-safe) data types, such as numbers, bools, and tables containing other gc-safe types, etc.
* Manual Managed data types, such as Roblox Instances, OOP Objects, etc.

The first type is very easy to work with and let Luau do the work for you as long as you carefully don't reference it forever. 

It's when you begin working with the manually managed data types that memory management become annoying because as the developer you should always pair a constructor call with a deconstructor call. That is, you can't `Destroy()` an Instance twice, but you must also call it one time.

As it turns out, this way isn't exactly great for developer experience and developers usually don't do this right.

## The Solution: Vinum Scopes

In Vinum, Scopes are a magical type where you can `table.insert()` into them stuff for cleanup, and also call constructors as methods from them. For example:
```lua
local Health = scope:Source(100)

table.insert(scope, Instance.new("Part", workspace))
```
::: info

Fun fact: Vinum constructors also technically call `table.insert()` as well internally, which means the only way to add something to a scope is to insert something to it
:::

Here, both Health and our Part will be cleaned up when our scope is destroyed.

The way they are designed is to assist luau in enforcing the usage of scopes, rather than making them an opt-in paradigm which means when you forget to use them, Luau will warn you ahead of time.

### Creating A Scope

To create a scope, first import the `Scoped` function, and then call it:
```lua
local Scoped = Vinum.Scoped

local scope = Scoped()
```

By default, `Scoped` returns a list of the constructors for Vinum objects (Maps, Sources, etc..) and an `Add` method that can be used for adding anything:
```lua
local mySource = scope:Source(...)
local myMap = scope:Map(...)

local myFn = scope:Add(function()
    print("hi")
end)
```

To cleanup a scope, import `Kill` and then call it on a scope:
```lua
local Kill = Vinum.Kill

Kill(scope)
``` 

Kill will cleanup the following:
* Roblox Instances; will get destroyed
* RBXScriptConnections; will get disconnected
* functions; will get called
* an OOP table with destroy/Destroy methods; the existing method will get called
* an array composed of subtasks.
* Vinum State Objects; triggers some special code to cleanup the value and related tasks.

To derive a new scope from an older one (as in, creating a new scope with new custom constructors), import `DerivedScope` and then call it with the scope and a list of constructors:
```lua
local DerivedScope = Vinum.DerivedScope

local dScope= DerivedScope(scope, {
    hi = function()...
})

dScope:Source(100)
dScope:hi()
```