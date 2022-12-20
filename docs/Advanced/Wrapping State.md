---
sidebar_position: 1
---

# Wrapping State

Sometimes, we often want to "wrap" events in the form of state objects. Most notably to wrap a Humanoid's `HealthChanged` to have an updated health state object. Of course, such a need is always common in partially-managed vinum data model, so usually you wouldn't need to use this if you have a completely-managed vinum data model.

## Usage

In order to use Wrap, we must first import its constructor:
```lua
local Wrap = Vinum.Wrap
```

Now, to use Wrap, we pass its constructor a signal *(that is either RBXScriptSignal or a custom one)*, and the number of the signal's arguments it will wrap, and the default values for those:
```lua
local timeState, deltaState = Wrap(RunService.Stepped, 2, 0, 0)
```
As you can see, Wrap doesn't create a fixed amount of state objects, instead, it creates a number of state objects that matches your second argument, which in our case is ***two state objects***. These two state objects represent the two arguemnts we are wrapping, the first one is for the first argument, and so on.

After the second parameter you pass in, you can pass the default values for the said state objects. The ***order of the default values is important***, wich means that the first zero in our example will be timeState's default value, while the second one is deltaState's one.

Now to read from our wrap objects, we can use their `get` method:
```lua
print(timeState:get(), deltaState:get()) -- time run service has been running for + delta time
```

Once we don't need our Wraps anymore, we can call their disconnect method:
```lua
timeState:disconnect()
deltaState:disconnect()
-- any changes will not be listened to
```
_____