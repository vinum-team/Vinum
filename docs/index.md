# Home

Vinum is a multi-paradigm library for powerful state management usage and is perfectly capable of running in performance-critical systems.

# Why Vinum?

* Vinum's implementation is ultra fast and is able to be used in the most performance-critical systems on Roblox.
* Vinum's API is declarative, therefore, you code in terms of end results rather than instructions.
* Self-containing and centralized state can be used independently of each other, but when you use them togther, it results in a readable and maintainable codebase.
* Vinum doesn't second guess you - In Vinum, you directly control the updates at the low level. This is because of `Processors` that Vinum asks from you every time you create an object - these functions return a boolean that will determine whether the update will pass or not. 