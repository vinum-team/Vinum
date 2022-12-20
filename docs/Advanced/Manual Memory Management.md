---
sidebar_position: 3
---

# Manual Memory Management

Memory management is something needed in general software programming, and it is no different when coding with Vinum.

## oldValue Cleanup

Since the release of Vinum v0.1, there was this concept of "old value cleanup", which to essentially clean/destroy the old value of a state object. As you might have guessed, this kind of behavior is done in ***stateful*** processors.

This type of memory management has already been introduced to you in the `Baiscs` chapter, so this section will focus on the need of such concept rather than how to use it.

Imagine a Hold object that holds an instance value:
```lua
local currentInstance = Hold(Instance.new("Part"), AlwaysTrue)
```

This is fine, however, what happens when we `set` our currentInstance with yet another instance?

Well, assuming that we have used any event that `currentInstance` provided, garbage collection won't work, therefore, our old instance will not get destroyed and ***can cause memory leaks***.

This can be fixed by using an another stateful processors that performs the necessary cleanup instructions. For example, we can use `RefuseIfSimilarAndCleanup`, which will cleanup the old value ***if*** the new value is a different one *(imagine setting a holder to its own value, which will cause unintended behavior)*.
______

## Manual Object Destruction

Since Vinum v0.2, state objects no longer get garbage collected if their root dependencies don't get garbage collected ***even*** if they are out of scope.

This is because automatic object destruction has caused a major issues with other Vinum's objects, even when they are ***not*** out of scope.

This has lead to the idea of manual object destruction, as after all, if a feature gets removed for no replacement, then the it is a flawed removal.

In order to use manually destruct objects, you must use the standard `Vinum.Destroy` method *(not to be confused with roblox's instance:Destroy() method)*, which does the following (order matters!):
1. Disconnect relations with all dependencies of the destructed object
2. Call `Destory` on all dependents
3. `table.clear` the state's object table, and then set its metatable to another that will error once indexed.

### When to Destroy: List

#### Process-created Objects
Sometimes, we create objects in a specific process, and depending on their duty, they may/may not need to be destructed.

Consider this Vusion example *(Vusion is a binding between Vinum and Fusion)*:
```lua
local function comp(props)
    return Fusion.New "Part" {
        [Vusion.Key] = {
            Transparency = Calc(function(useState)
                -- some computations here
            end, Vinum.AlwaysTrue)
        }
    }
end
``` 
In this example, we create a new Calc object every time `comp` is created. This however is ***dangerious***, since whenever we call `comp`, we create copies of our calc object, which means memory leaks, and wasted computational power will occur.

To solve this, we could call Destroy on all Calc objects that we create every time `comp` is called.

#### Instance Bindings

Instance bindings are very common in Vinum codebases, as they are the layer at which you derive state from your main data model *(that is the one managed by Vinum)*, and reflect it on the Roblox's datamodel.

Internally, all instance bindings use an `observe`, which we would eventually want to cleanup once the binded instance is destroyed:
```lua
local function bindWithInstance(state, propName, instance)
    local observer = Observe(state, AlwaysTrue)

    observer:onBind(function(newValue)
        instance[propName] = newValue
    end)

    instance.Destroying:Connect(function()
        Vinum.Destroy(observer)
    end)
end
```