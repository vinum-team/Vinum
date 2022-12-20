---
sidebar_position: 4
---

# Reflecting State

Reflecting State is an another Vinum tool that allows you to create "readonly" copies of a specified state object. The object in question is *Reflect*.

## Usage

In order to use Reflect, we must first import its constructor:
```lua
local Reflect = Vinum.Reflect
```

And now to create a `reflector`, we pass to the constructor a state object that we will reflect:
```lua
local holder = Hold(100, AlwaysTrue)
local reflector = Reflect(holder)
```

And to read from our newly created object, we use its `get` method:
```lua
print(reflector:get()) -- 100
```
Now, any changes to `holder` will also be sent to our `reflector` object.
___

## Why State Reflection

It is obvious that the behavior that `Reflect` provides is *already* provided by Mirror in a different form.

The motive however behind this is that `Mirror`ing a single state object requires a bit of boilarplate code to get it working, and can overcomplicate your codebase as your project grows. As such `Reflect` was born, a type of object that ***is*** a reflection, meaning that it doesn't contain any identity or in other words, all other objects when being provided with a reflector object, will directly communicate with the reflected object instead. 

That being said, Reflect specifically solves the following:
1. Boilarplate code when mirroring a single object
2. Readonly state objects

### Readonly State 

As you can see, one of the issues that Reflect addresses is the creation of readonly state copies.

*Readonly state* is an important feature, as it is sometimes needed to explicitly prevent some places from being able to write to our state objects.