---
sidebar_position: 1
---

# Vinum
Vinum is an incredibly fast reactive state management library that exposes a very declarative interface that allows you to build scalable state-dependent software on Roblox

## Why you should use Vinum: Summary
* Multi-paradigm
* Blazingly fast
* Strict and Flexible
* Declarative
* No manual dependency management

## Why you should ***not*** use Vinum
* Is an unstable technology- desipte it being a unit tested, it is still considered unstable because its API can and will change at any time.
* It doesn't have a mature software ecosystem- although generally Vinum is built to provide you most of what you need in fundemental objects.
* No current bindings to other UI view libraries such as Fusion & Roact- although, a port for Fusion is planned. Though these ports can be manually implemented very easily.

## Inspiration From Prior Work
1. [Fusion](https://elttob.uk/Fusion) by Elttob
    * We took inspiration from Fusion in the API design as it matched our goals.
2. [BasicState](https://github.com/csqrl/BasicState) by Csqrl
    * We took some inspiration from BasicState's approach for state centralization
3. [Rodux](https://roblox.github.io/rodux/) by Roblox
    * We took Reducers, and changed them to Processors which are simple functions to determine if an update can pass or not.