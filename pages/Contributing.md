# Contribution to The Vinum Project
Vinum as a project welcomes contributions from the community as a whole, however, we expect the community to read this guidelines thoroughly so that nobody's time is wasted.

### What is a Contribution

You might say that contribution is any change in Vinum's codebase by the community, and you are right! However, contribution isn't restricted to Vinum's own codebase, in fact, any library that is supposed to port Vinum to another language *(roblox-ts)*, any binding library is considered as a contribution to the Vinum Project *(the keyword here is Vinum Project)*.

So, a "contribution" can be:
* A pull request that implements a feature -- still not available for public
* An issue describing a bug or a feature
* Developing bindings for other librarys, most notably UI view ones
* Developing ports for other languages, most notably roblox-ts. -- still not available for public

:::danger
Important! The guidelines for ports and bindings are solely meant to be followed by the respective libraries maintainers with how they implement their library, rather than a strict guidelines for repository management.
:::

### Issues: Feature Suggestion
Vinum welcomes feature suggestions/requests from the community, however it is important to know what type of features we are specifically looking for.

These are what we generally accept:
* **Styling imperative tasks with declarative API** - Vinum's standard library should offer tools that perform imperative tasks in a declarative style.
* **Should be fast and readable** - Vinum's standard tools should generally be fast, and on top of that, have an understandable codebase/API.
* **Should have a global use case** - Vinum's standard library should only contain tools that have a universal use between Vinum's projects.

These are what we generally reject:
* **Prefers writability over readability** - Vinum's standard library code should be implemented in a readable way, and avoid some "writability optimizations" such as abbreviated names like RS for replicated storage.
* **Is magic** - We generally tend to reject features that are considered magic systems that Just Work.

If you believe that your feature respects our guidelines, and would like to open and issue, please continue:
* **You are the first one to suggest it** - You make sure of that by searching for issues that are either closed/opened in Github's issue tracker.
* Only if this feature hasn't been suggested before, make sure that:
    * **The meta information is valid** - Titles should be properly sensible, and descriptions should be provided.
    * **API suggestions shouldn't generally be suggested, but feel free to put some examples** - Vinum doesn't generally accept API designs, however, it's okay to put some examples.
* **Be patient - all project maintainers are voluteers**, so it will likely take some time to respond.
    * Don't bump or chase up your issue - commenting 'Any updates on this?' does not add value to the conversation, and only clutters the issue.

### Issues: Bug Reports
Vinum welcomes bug reports, so that we make it better- however, make sure that you follow the guidelines for bug reports so that nobody's time is wasted. Here is what you do when you find a bug:

* **You are the first one to report it** - You make sure of that by searching for issues that are either closed/opened in Github's issue tracker.
* Only if this bug hasn't been reported before, make sure that:
    * **The meta information is valid** - Titles should be properly sensible, and descriptions and repro files should be provided.
* **Be patient - all project maintainers are voluteers**, so it will likely take some time to respond.
    * Don't bump or chase up your issue - commenting 'Any updates on this?' does not add value to the conversation, and only clutters the issue.

## Third-party: Bindings
Bindings are simply put, a collection of libraries that have a single goal, which to make usage between two libraries easier.

Vinum, as a project, has a certain guidelines to ensure a somewhat "standard" feel across community-made bindings.

### Versioning: [X=Y]: Z
The versioning for Bindings is advised to follow a specific format, which is [X=Y]: Z; The X is the current version of the library we are binding to, while Y is the version of Vinum we are binding with, and Z is the binding version.

### Use Public APIs *only*
You should generally use the APIs you are provided with- this is the case with Vinum, and the other library.

### Don't Recode

You shouldn't generally recode places, or offer "rewrites" of certain features so that you can support Vinum.

i.e:
```lua
local function VNew(name, props)
    -- rewrite the whole New function from Fusion just to allow binding to Vinum objects.
end
```