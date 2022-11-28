# Processors

Processors in Vinum are pure functions that give you control whether you want updates to pass or not. Additionally, they are the best places to include logic such as destruction, middleware, and various mechanisms such as `Vinum.RefuseIfSimilar`. 

## *Stateful* State Objects VS *Stateless* State Objects

In Vinum, there are two types of "state objects" in - one is *Stateful* and the other one is *Stateless*. It can be quite ironic that some "state objects" are stateless, however this separation helps us understand what exactly to put in Processors.

### Stateful
*Stateful* State objects have the ability to have their own state attached to them, examples of these are `Hold`, `Calc`, and both `Match` & `Groups` *(You will be introduced to them at a later point)*.

These objects always have a method that is used for reading their values, and sometimes a method for value mutation. Due to this ability, Processors that are used with this objects should be used to manage how their respective objects should signal out updates- i.e Processors that dismiss updates if produce the same value.

tl;dr Processors for *Stateful* objects are the best when writing middleware that acts as **Should I signal this update**.

**Standard Processors**:

1. `Vinum.RefuseIfSimilar` - This dismisses updates if they produce the same value. Doesn't work for groups.
2. `Vinum.RefuseIfSimilarAndCleanup` - This dismisses updates they produce the same value, otherwise, it accepts them and attempt to cleanup the old value. Doesn't work for groups.
    * Supported cleanup types: Instances, RBXScriptConnections, function, custom objects that have d/Destroy methods, or arrays that contain supported types
3. `Vinum.RefuseIfSimilarInGroup` - Same as #1, but instead only works for groups
4. `Vinum.RefuseIfSimilarAndCleanupInGroup` - same as #2, but instead only works for groups.
5. `Vinum.JustOk` - This accepts any update.

### Stateless
"Stateless" State objects don't have the ability to have their own state attached to them, the only example if them is `Observe`, which doesn't hold any state to itself.

Processors for these objects should be used as a way for filtering updates from their respective objects. This is more of a **Should I receive this update**. 

**Standard Processors**

1. `Vinum.JustOk` - This accepts any update.