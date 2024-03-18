# Storing Simple Data
The simplest way to store state in Vinum is through `Sources`, which are simple state containers with no special behavior:
```lua
local myHealth = scope:Source(100)
```

::: warning Operator-Safe
`Source` is a table that adheres to ReactiveObjects, meaning it can be used with Vinum's Supplied [Operators](./operators).
:::

::: danger Unsafe Public Indexing
`ReactiveObject`'s structure isn't stablized between versions, as such you aren't recommended to directly index its fields directly.
:::

The sole reason for Source's existence is the vital need for a basic container that ***just*** stores whatever data you input into it. As such, Sources are considered one of the vital building blocks of any Vinum code.

### ReactiveObjects: Why and How

Consider the following code:
```lua
local coins = 100
local doubleCoins = coins * 2
```

In this example, doubleCoins are set to the value that is half coins' value, but only for ***once***. This is due to the fact that Luau variables aren't capable of storing other values that use them in their computations, or in simpler words, don't store their dependents. As such, the responsibility of keeping your state synced is in your own hands, which turns out to be a bad developer experience because no matter the approach, you will have to manually store a list of dependents.

As such, ReactiveObjects were born to solve the issue of reactivity in luau. They are simple objects that store a `type` and`value` fields alongside some internal values. 

As a user, you wouldn't create them directly and instead use something like `Source`s. Additonally, they don't store methods and instead are operated on using [Operators](./operators).