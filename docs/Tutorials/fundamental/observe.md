# Observing State

We often want to listen to changes on our state, which we can use `Observe` for that.

`Observe` is an object that allows you to run code in response to a change in another state object.

Before creating an `Observe` object, we first need to import it:

```lua
local Observe = Vinum.Observe
```
Now, to create an `Observe` object, we first need to feed its constructor an inputState and a processor. Keep in mind that `Observe`s' processor provides only one parameter, that is `newValue`.
```Lua
local health = Hold(100, Vinum.RefuseIfSimilar)

local healthObserver = Observe(health, function(newValue)
    return true
end)
```

Now to connect a handler, we use `healthObserve:onChange()`.
```lua

healthObserver:onChange(function(newValue)
    print(string.format("Health changed to %s", newValue))
end)
```

Now, when we change `health` to 50, `Health changed to 50` message will be printed.

```lua
health:set(50) -- the observer will automatically print `Health changed to 50`
```

Additionally, `...:OnChange()` returns a disconnecter, which is just a function that disconnects your handler.

??? Question "Why disconnecting is important"
    While currently Vinum doesn't really care about whether you disconnect connections or not since they can get GC'ed, in the future, Vinum will perform some voodoo magic that will optimize `observe`s without a handler, and apply some memory safety features.
_______

# What is a Change?

You may think it is a simple question and has a simple answer. However, the answer this question is very flexible, and heavily depends on how you manage updates in Processors.

For example, the above example, `health`'s Processor doesn't allow updates that compute the same result, and the `healthObserver` allows all update.

However, in another scenario, we may use another helper that is:
```lua
function(oldValue, newValue)
    local oldType = typeof(oldValue)
    local newType = typeof(newValue)

    return oldType == newType and oldValue ~= newValue
end
```

This helper is very simple, it implements typechecking and the same mechanism as `Vinum.RefuseIfSimilar`.

??? danger "Runtime Typechecking"
    Implementing Runtime typechecking is heavily discouraged in Vinum as it decreases performance and adds more bloat. 

    Instead, you are recommended to use your IDE's static typechecker. Additionally, Vinum is typed, so it is able to tell you what value it expects from you.

    Static typechecking has a few advantages over runtime typechecking, which are but not limited to:

    * Improved performance
    * ***Almost*** everything is debuggable from your code editor i.e you don't need to run the whole game to check whether you are passing the wrong type to your state objects.
    * Decreased Code bloat and increased code maintainability.

When we use that helper for our `health` state, we are directly changing when it updates and fires observes, which can be summarized in a few points:

* if we set `health` to a value that has a different type than the old one, `healthObserver` won't fire any connections
* AND if we set `health` to the same value, `healthObserver` won't fire any connections.