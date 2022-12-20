---
sidebar_position: 4
---

# Processors

Processors are the most essential part of Vinum, they give you control to change the control flow of updates to some *extent*.

However, Processors themselves have different types, and each type has a specific usecase tied to itself. The factor that the classification is based off is simply if they're aware of the respective state object's old value or not.

That being said, Processors have only two types; ***stateful*** processors and ***stateless*** processors, and you have actually used the both!

## Stateful Processors
Stateful Processors are really simple, and are responsible for their object's update flow, and general cleanup if needed. Consider this an implementation of a stateful processor for a Hold object:
```lua
local function HoldProcessor<T>(oldValue: T, newValue: T): boolean
	return oldValue ~= newValue
end
```

This has a really simple behavior, which is:
* If the old value is equal to the new value, dismiss the update
* otherwise, pass the update

Stateful Processors, just like previously mentioned, are the best places to manage our object's update flow, and additionally, we can perform general cleanup as well there.

### Standard Stateful Processors
* `Vinum.AlwaysTrue` - Always returns true
* `Vinum.RefuseIfSimilar` - Returns false if the oldValue is the same as newValue
* `Vinum.RefuseIfSimilarAndCleanup` - Same as RefuseIfSimilar, but performs cleanup when an update is passed
* `Vinum.RefuseIfSimilarInGroup` - same as RefuseIfSimilar, but acts as a port for Groups.
* `Vinum.RefuseIfSimilarAndCleanupInGroup` - Same as RefuseIfSimilarAndCleanup, but acts as a port for Groups

Types that cleanups accept:
* Instance: Destroy
* RBXScriptConnnection: Disconnect
* Function: Call
* Table that has destroy/Destroy: Distroy
* Array of tasks: call the cleaner on each subtask

## Stateless Processors

Stateless Processors, unlike their stateful counterparts, act as places for ***filtering***. Though it is important to keep in mind that ***cleanup should NOT be perfomed in stateless processors***- this is generally because stateless processors are used in objects that ***don't*** have any state, therefore, they use the object's dependency's value, so any mutation of the said value is disallowed.

### Standard Stateless Processors
* `Vinum.AlwaysTrue` - Always returns true
