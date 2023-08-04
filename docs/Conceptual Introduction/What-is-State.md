---
sidebar_position: 1
---

# What is State

## Intro
A State is a very vague term for some of you, and this is understandable. This can also result in people getting confused between a method that stores and represents state, and the state itself.

## Body
A program is considered stateful, if its able to correctly remember the condition of its stored inputs, the same ones that of course control the program's behavior.

An illustration for this definition could be something like this:
```
    PlayersName = GetPlayer().Name

    Observe(PlayersName):
        someUI.Text = PlayersName
``` 

Observing this illustration, we could see that our program is able to effectively remember the value of our `PlayersName` state. Due to this, its considered stateful, as it remembers past inputs and their current values.

Just like State in real life, a thing can hold more than one single state, and one of those states can hold more than one state as well, and so on. This means for example, our program's general state is that its rendering a specific page, while the state of the said page is rendering `A Text Label, Text Button, etc`, and the state for the Text table is `Text = PlayerName, Color = Black`. And of course, the PlayerName state could have stored state within it, for example a player's name could be "Sinlernick", and our state could process it and return "Player-Sinlernick".

This being said, a simpler definition could be "state is data that controls a program's behavior". Do you have a `Health` state? Well, it will change the program's behavior, from changing a health bar UI, to some internal systems such as character spawing and so on.

## Conclusion

At the end of the day, State is simply ***dynamic data that changes how your program behave***.