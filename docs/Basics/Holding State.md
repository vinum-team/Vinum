---
sidebar_position: 1
---

# Holding State

In Vinum, one of the most basic tools that are provided is `Hold`- hence the name `Holding State` is chosen. They are useful for holding data, and allowing them to be used by other Vinum objects.
```lua
local value = Hold(100, function(oldValue, newValue)
    return true
end)

print(value:get()) -- 100
value:set(50)
print(value:get()) -- 50
```

## Usage

In order to use `Hold`, you must import its constructor, which you can do by:
```lua
local Hold = Vinum.Hold
```

And to create a Hold object (more known as a Holder), we pass an initial value, and a Processor- for now, you don't need to fully understand what a Processor is, just treat it as a function that allows you to drop/allow updates.
```lua
local holder = Hold(100, function(oldValue, newValue)
    return true
end)
```

:::danger
Storing nils as initial values is considered very dangerious, and is recommended to refrain from
depending on, as any possible outcome from doing so is considered undefinied behavior/
:::

To write to our Holder object, we use its `:set()` method:
```lua
holder:set(400)
```

This writes to our holder object ***if*** our definied Processor function allowed it, which in our case, any write request is allowed and normally processed.

Now, to read from our holder object, we use its `:get()` method:
```lua
print(holder:get()) -- 400
```
_______

## Problem with Luau Variables

Variables in Luau aren't *reactive*, meaning that they don't capture their dependencies and they don't recompute once a dependency changes.

This can be very problematic as it is a gateway for hard to find bugs that are often data desynchronization.

Consider this code example:

```lua
local coins = 100
local price = 50

local finalCoins = coins - price
```

This is simple and if you tested it, it works fines, however, `finalCoins` ***isn't*** reactive, meaning that any changes either to `coins` or `price` don't cause `finalCoins` to update as well.

You could obviously fix this in this example, however even using a "scalable" solution wouldn't be even quite scalable. An implementation of this totally awesome solution is to have a setter function for each variable, like the following:

```lua

local coins = 100
local price = 50

local finalCoins = coins - price

local function setCoins(newValue)
    coins = newValue

    finalCoins = coins - price
end

local function setPrice(newValue)
    price = newValue

    finalCoins = coins - price
end

setPrice(1)
setCoins(2)

print(finalCoins) -- 1
```

In this example, we eliminated the issue where we needed to repeat the process of updating every dependent, however, ***the setting code is still concerned with its respective owner's dependents***- that means, that adding on more dependencies to an object will result in a much more complex code base- after all, we did all of this just to satisfy our "reactive" needs for an object that only has ***2 dependencies***. 

## The Fix: Better Variables

To satisfy our *reactive* state management needs, we need to fundamentally extend what a variable can do. Unlike luau variables, which aren't really reactive, and aren't self-aware- our solution objects need to be very aware of their dependencies and dependents, and to have a way for us to safely read and write.

Both technically and internally speaking, all the objects Vinum provide you aren't really self-aware on their own, instead, they use an internal object that is called `graph` that manages their dependencies.

These objects contain a list of dependencies, which are used for the "self-aware" guarantee, which is also a helpful feature for future optimizations. In addition, they also contain a list of dependents, which is used for actually upating places that are currently using the said `graph`'s owner.

From an user standpoint, Vinum addresses this problem by providing you tools like `Hold`, which are direct replacements for variables that are being used as "state **hold**ers". This is because they give a way to read data ***and*** a way to write to that data- making `holders` a literal variables that are embodied as an object.

### A Side benefit: Standard Method Of Reading

A side benefit that we gain from such approach is that we have a "standard" way of reading across same-paradigm objects, not caring about how that data is accessed, making it easy for us to build more reusable and robust code.

For example, let's have a look at this example:
```lua
local function AlwaysTrue()
    return true
end

local X = Hold(true, AlwaysTrue)
local Y = Hold(false, AlwaysTrue)

local function makeBinding(state, instance, propName)
    return Vinum.Observe(state, AlwaysTrue):onBind(function(newValue)
        instance[propName] = newValue
    end)
end

makeBinding(X, Part, Anchored)
makeBinding(Y, anotherPart, Anchored)
```

Here, we just wrote a function that creates an Observe, and connects a binding using them, which sets the newValue to the instance's propName. For now, you don't need to understand Observes at all, just know that they are objects that fire all of their connections once there is a change in their dependency.

Aside from that, we are **reusing** `makeBinding` for two different objects, *and soon enough, you will see that it is so flexible that you can reuse makeBinding with almost every other state object*.
