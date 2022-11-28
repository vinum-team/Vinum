# State Calculating
In this tutorial, you will be introduced to a new object that will allow for efficient derived values, that is `Calc`!

We first need to import its constructor:

```lua
local Calc = Vinum.Calc
```

Now, to create a calc, we first need to feed two parameters into its constructor, one that is the calculator, and the other one is the Processor.

```lua
local dynamicMidHealth = Calc(function(useState, useKeyState)
end, function(oldValue, newValue)
    return true
end)
```
??? warning "Processors and Calcs"
    Internally, on creation, Calcs use the same pipeline as updating them, so your Processor should account for that. To make this easier for you, Vinum right before updating the Calc, attaches a value that is `{type = "Symbol", value "None"}` to it.

At the moment, you don't have to worry about `useKeyState`, it is just another method for interaction with another object. On the other hand, `useState` is a helper function that is used for subscribing dependencies into the Calc.

Using `useState`:

```lua

local health = Hold(100, Vinum.RefuseIfSimilar)

local midHealth = Calc(function(useState)
    return useState(health) / 2
end, Vinum.JustOk)
```

Now to get the value, we use `midHealth:get()`:

```lua
print(midHealth:get()) -- 50
```
______

# When to use Calcs

Calcs are a little bit more speicalized than Holds and Observes. They are designed to make it easy to derive new values from existing state objects.

Derived values are very common in statefull systems, such as UIs. For example, if we have a death message that includes `Killed By`, then it needs the killer's name as a dependency.

This is possible using Observe and Hold alone, although your code will get ultimately messy.

Consider the following code that doesn't use Calc. The intent is to create a death message that is synced at all times.

```lua
local Killer = Hold(PlrObject, Vinum.JustOk)
local Message = Hold(string.format("I got killed by &s", Killer:get()), Vinum.JustOk)

local killerObserver = Observe(Killer, Vinum.JustOk)
killerObserver:onChange(function(newValue)
    message:set(string.format("I got killed by &s", newValue))
end)
```
There are a few problems with this:

* It isn't clear at first what this code is doing, making it harder to reason about.
* This will get overly complicated once we start introducing more dependencies.
* Logic is repeated, when `Message` is created and in `killerObserver`'s connection.
* You manage the pipeline, which means desync bugs can slip in

While with a Calc object:

```lua
local Killer = Hold(PlrObject, Vinum.JustOk)

local Message = Calc(function(useState)
    return string.format("I got killed by &s", useState(Killer))
end, Vinum.JustOk)
```

* This is clear and is easier to reason about.
* It is scalable - you can add as many dependencies as you want, and chances you will get a readable code are still high.
* Logic is all contained in Calc's callback
* Calc's manages its own pipeline, which means it is less prone to errors.