---
sidebar_position: 2
---

# State Modeling

*While this isn't strictly tied to Vinum, it's often preferred to know how to model your Vinum DataModels with Roblox's DataModel (that is the `game` global).*

## Source Of Truth

Firstly, the Roblox DataModel is an instance that holds all sort of stuff in your game, which Luau can access it using the pre-definied `game` global. The DataModel can also be called DOM, or in other words, The Document Object Model, which is a term borrowed by the Web world.

Whether its a well-thought decision, the source of truth for your game state either lives in some Luau table, or in the DataModel.

As an example, most games on Roblox use the Humanoid's Health property as a source of truth for all Health-related operations. Therefore, the source of truth for the player's health lives in the DataModel. This can and will lead to issues later down in the line, however, more on this later.

On the other hand, imagine you are making an obby, and you store what level a player is currently at, and this could be stored in a table like this `{[Player]: number}`, which we will call "currentLevelMap". To display this to the user, we can update some UI's text everytime the current level for the respective player changes. This is an example of the source of truth living in your code. The `currentLevelMap` is the source of truth for which level a player is at, and you update the DataModel to better reflect this.


Some games use the first approach, which is storing everything in the DataMode, and some games use only the second approach, and some other (which are usually higher than the rest), use a mix of both. This documentation only targets the first and the last group.

Usually, storing data in the DataModel directly can cause some inconvenient issues due to objects' and properties' in the DataModel inability to better represent complex structures, such as tables. While you can go around this by using an attribute just as an "field" like in a table, this will get worse as it will get infinitely harder the more complex the structure is.

Your Codebase gets simpler by a ton when you think of the DataModel as just a representation layer of your Luau state, or in our case, Vinum state!

## Single Source of Truth in Vinum

Before we dive deep into how we will reconcile Vinum State to the DataModel, an important core concept is to understand how to even model your Luau State that is managed by Vinum!

A Single Source of Truth is a core concept that you usually need to avoid your data being stored in different data models, which can make reading them harder. 

Instead of writing a wall of text explaining what solution Vinum provides for this issue, we will rather write some pseudocode code that resembles vinum's objects:
```lua
    charInfo = Value {
        Health = 100,
        Speed = 16
    }
```

Now that we have a charInfo state object that contains some useful data about our character. Of course, processing the charInfo will require us doing some table operations, which is while easy, the tools for it isnt provided by Vinum for now. So instead of doing that, we could take a "selection" of charInfo.

For an example:
```lua
    charInfo = Value {
        Health = 100,
        Speed = 16
    } 


    -- Character.code
    HealthKey = KeyOf (charInfo, "Health")
    Character = {
        takeDamage = func(num):
            set(HealthKey, num)
    }
```
As you can see in the example, you would usually want specific systems only be able to directly interface with the state objects. Since sometimes, you dont want every system that wants to reduce the health for a character to search for that specific state object.

Of course, perhaps you love Rodux, and love its way of implementing centralization. 

For an example:

```lua
    vinumStore = Hold ({Health = 30, Speed = 20}, alwaysTrue)


    setRodux(vinumStore, {
        Health = 20
    }) -- setRodux is a custom function!
    -- "Speed" isnt removed!
```

Now, you could technically have a big object that holds the entire state datamodel! 

This is a very simple explaination about various aspects of how to model your luau state model, so concepts like state centralizations/single source of truth will be explained in details in its own respective page when you eventually learn how to use Vinum!