---
sidebar_position: 2
---

# Observing State

State observation is a fundemental tool that allows you to bind some functions that will run whenever an update is ran in an observed state object- that is `Observe`.
```lua
local value = Hold(100, function(oldValue, newValue)
    return true
end)

local valueObserver = Observe(value, function(newValue)
    return true
end)

local disconnector = valueObserver:onChange(function(newValue)
    print(newValue)
end)

value:set(40) -- 40 is printed
disconnector()
value:set(40) -- 40 isn't printed
```

## Usage

In order to use `Observe`, we first need to import its constructor:
```lua
local Observe = Vinum.Observe
```

To create an `Observe` *(known as Observer)*, we feed its constructor a state object to listen to, and a Processor function:
```lua
local holder = Hold(true, function()
    return true 
end)

local observer = Observe(holder, function(newValue)
    return true
end)
```

Now to connect a function to our `observer` object, we use its `onChange` method, like so:
```lua
local disconnector = observer:onChange(function(newValue)
    print(newValue)
end)
```

Additionally, the `onChange` method returns a function that disconnects the connection you just connected:
```lua
disconnector()

holder:set(false)
-- newValue isn't printed
```

And to bind a function, you can use its `onBind` method, which immediately fires the given function, and then acts the same as `onChange`:
```lua
local anotherDisconnector = observer:onBind(function(newValue)
    print(newValue)
end)
-- false is printed
holder:set(true)
-- true is printed
```
______ 
## What is a Change

A *change* in Vinum is a very flexible term, and ***heavily depends on your code***.

In the `Usage`'s example, a change means any change that occured in `holder`, so any `set` calls that set the same value, an update will take place- this is because the processors we defined for both of them returned true always.

However, in another example, we might modify the `holder`'s processor to refuse any change that returns the same value as our old one- this heavily changes the term `change` in this situation, as now, a "change" means any change to the value that does indeed affect the value. 

Additionally, we might modify our `observer` processor so that any calls that set a number that isn't even, will not result in an update- alongside the same modification that we applied to our holder's processor in the first example.

This means that a change means in this ***situation***:
* Any changes that result in the same value will not cause an update
* Any changes that result in a ***number*** that is even.
______
## Binding Vs onChange

Observers offer two methods that allow for:
1. Connection that will fire once a change occurs- which is `onChange`
2. Bindings that will fire the moment they are provided, and connect a connection- which is `onBind`

onChange has a very simple and low-level usecase, which is just a connector that connects functions that will run once a change occurs. This is a very fundamental behavior that allows you to do ***everything***- However, because it does only care about a low-level case, sometimes it forces you to write behavior twice or x more such as binding an state to an instance's property.

On the other hands, onBind has a very specific usecase to support, which is to make binding more declarative.

Take this for example:
```lua
local function alwaysTrue()
    return true
end
local counters = Hold(100, alwaysTrue)
local observer = Observe(counters, alwaysTrue)

thisInstance.PropertyName = counters:get()
observer:onChange(function(newValue)
    thisInstance.PropertyName = newValue
end)
```

This **works**, although it forces you to write the setting behavior twice, both in 7 & 8. 

So instead, you can do this:
```lua
local function alwaysTrue()
    return true
end
local counters = Hold(100, alwaysTrue)
local observer = Observe(counters, alwaysTrue)

observer:onBind(function(newValue)
    thisInstance.PropertyName = newValue
end)
```

Technically speaking, `onBind` is a form of a wrapper that internally uses `onChange` added to the standard library to make universal code more understandable to general Vinum users.