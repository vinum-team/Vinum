# Contributing to Vinum
Please refer to this [page](https://plothan.github.io/Vinum/Contributing) for a detailed guidelines about what type of contributions we like the community to give- However, this page will explain in detail on how the Vinum Project as a whole (not just the library!) is structured.

## External & Internal Tooling
The Vinum Project makes use of internal tooling, embodied in the form of frameworks such as the unit testing and the benchmarking ones; these are placed in the `code-runners` directory.

As for external tooling, the Vinum Project makes use of Rojo, Wally, Selene, Stylua, and luau-lsp. The specifications for these tools (alongside their versions) can be found in [aftman.toml](aftman.toml).

## DevProject Structure

In Vinum's root, there is a file that is named `dev.project.json`. This file is responsible for building and syncing the development file using Rojo.

This file is the specification for the following structure that will be built in Studio:

```
- game
    - ReplicatedStorage
        - benchmarks [folder] - Vinum/benchmarks
        - tests [folder] - Vinum/tests
        - Vinum [module] - Vinum/src
    - ServerScriptService
        - runner [script] - code-runners/runner.server.luau
        - Tester [module] - code-runners/Tester
        - LuauBencher [module] - code-runners/LuauBencher
```

Of course, there are plans to change that structure because of some issues with how testing works because of that very specific structure, although you are recommended to not do it yourself, as it will ultimately get harder to modify new Vinum versions without losing any progress.

## Style Guide

While Vinum follows most of the Roblox Lua Style guide, there are a few changes, such as how we write classses, and case the Public API.

To know how we write classes, please refer to any of the files in `src/objects` folder.

For casing the API:
All class members are camelCase, while Classes themselves are PascalCase case.

All non-object-constructor public APIs are camelCase.