---
sidebar_position: 3
---

# Calculating State

In Vinum, there is a way to implement derived values at scale, which is `Calc`s. These are equiped with *injector* functions that allow you to explicitly define the dependencies that will be used.
```lua
local value = Hold(100, Vinum.AlwaysTrue)
local valueCalced = Calc(function(useState)
    return useState(value) * 2
end, function()
    return true
end)

value:set(50)
print(valueCalced:get()) -- 100 is printed
```

## Usage

To use Calc, first import its constructor:
```lua
local Calc = Vinum.Calc
```

Now to create a Calc, pass a calculator function, and a processor function:
```lua
local value = Hold(100, Vinum.AlwaysTrue) -- A processor function that always returns true
local calced = Calc(function(useState, useKeyState)
    return useState(value) * 2
end, function(oldValue, newValue)
    return true
end)
```

And now to read from that calc, we use its `get` method:
```lua
print(calced:get()) -- 200
```

And now, all updates will return be applied, as our `value` object allows all updates, and our `calced` does exactly the same. For more information, read `What is a Change` in [Observing State](./Observing%20State.md#what-is-a-change).
_____

## Why Calc
Calcs are a little more specific than regular observes and holds. They are designed for a single use case, and it is to make deriving from state object possible without efficiency loses or scalability issues.

Dervied state is quite common in many of stateful systems, whether they are UI-related, or generally player state. For example, you may want to show our player's health in a UI- and since technically, we can't put the raw health, *we have to derive a new state that processes the raw health to a Udim2*.

***Of course***, this is quite possible with Observes and Holds, however your codebase **will** get messy eventually:
```lua
local rawHealth = Hold(100, function()
    return true
end)
local healthUdim2 = Hold(UDim2.new(), function()
    return true
end)

local healthObserver = Observe(rawHealth, function()
    return true
end)

healthObserver:onBind(function(newValue)
    local hUDim = UDim2.new(rawHealth:get()/ 10, 0, 1, 0)

    healthUdim2:set(hUDim)
end)
```

However, there are some issues with this current approach, most notably:
* This isnt easy to reason about at first glance- There are a lot of holds and observes that make the overall implementation a bit messy.
* We are manually managing dependency, which means desync bugs can slip in!
* We created ***two*** objects just to derive from a ***single*** state object- Can you imagine what we have to do when we have more dependencies?
* Anybody can change `healthUdim2` at any time- This can be solved using a certain object, however, it will only make it more harder to maintain. Plus, you will eventually invent Calcs accidentally.

These issues are largely fixed in an calc-based implementation:
```lua
local rawHealth = Hold(100, function() 
    return true
end)

local healthUDim2 = Calc(function(useState)
    return UDim2.new( useState(rawHealth) / 10, 0, 1, 0)
end, function()
    return true
end)
```

We solved the previously mentioned issues because of:
* The intent is very clear, which is to create a UDim2 that represents the current health
* State management is ***explicit***, but not ***manual***- which means, you explicitly tell the Calc what state objects you are deriving from, however, you aren't doing any dependency management work really.
* We just created a singular object when we previously needed two- and the fun part is that this number isn't linear, which means we still need one object for whatever number of dependencies, while with the previous approach, we need to create a lot of observers *(which will eventually lead to code duplicates)*.
* Our object isn't writable at all, which means it is safe to say that any behavior that depends on this state is predictable.

## useState and useKeyState: Injectors
You might have noticed these functions and their use in `Calc`, and you are wondering what are they, and why they exist. These functions are called *injectors*, as they are functions that get injected to the callback, and you also use them to *inject* dependencies into a Calc object.

Their usage is simply enough to provide a way for you to explicitly define the dependencies, the implicit approach where we automatically detect define our dependencies. This is of course to avoid the headache that comes from automatic detection, most notably:
* When it is implicit, it's very easy to define an object as a dependency to an unrelated object.
* The automatic detector is technically thinking for you, which can be considered a magic system that Just Works.

Injectors greatly solve this by simply introducing the idea of explicitness and strictness. However, since all injectors share the same goal, why there are two injectors?

The answer is that the first one, `useState`, is an injector that accepts the self-contained Vinum objects, such as Calc and Hold , while `useKeyState` is a special injector that is used alongside *Groups* which are objects that act as centralized state. Since `useKeyState` is largely tied to them, it is unneeded to explain it *right now*.

In the next section, you will be properly introduced to the idea of *Processors*, what are they, and what are their properties.