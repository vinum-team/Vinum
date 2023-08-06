# Contribution
All contribution to Vinum is highly welcomed. However, to ensure clarity and that nobody's time is wasted here, we enforce a contribution guideline.

## Guidelines
### Feature Requests
We love feature requests, however, we have a tiny bit of guidelines that make it clear what type of features we want to implement to the core library.

These are what we generally accept:

* **Styling imperative tasks with declarative API** - Vinum's standard library should offer tools that perform imperative tasks in a declarative style.
* **Should be fast and readable** - Vinum's standard tools should generally be fast, and on top of that, have an understandable codebase/API.
* **Should have a universal use case** - Vinum's standard library should only contain tools that have a universal use between Vinum's projects.

These are what we generally reject:

* **Prefers writability over readability** - Vinum's standard library code should be implemented in a readable way, and avoid some "writability optimizations" such as abbreviated names like RS for replicated storage.
* **Is magic** - We generally tend to reject features that are considered magic systems that Just Work. Tools like automatic dependency capturing fall under this.

If you believe that your feature respects our guidelines, and would like to open and issue, please continue:

* **You are the first one to suggest it** - You make sure of that by searching for issues that are either closed/opened in Github's issue tracker.
* Only if this feature hasn't been suggested before, make sure that:
    * **The meta information is valid **- Titles should be properly sensible, and descriptions should be provided.
    * API suggestions shouldn't generally be suggested, but feel free to put some examples.
* **Be patient** - all project maintainers are volunteers, so it will likely take some time to respond.
* Don't bump or chase up your issue - commenting 'Any updates on this?' does not add value to the conversation, and only clutters the issue.

## Development Workflow

### Installing Tools
Developing Vinum requires few tools so that it can run. Fortunately, these tools are managed by Aftman. 

The version for Aftman that we use for Vinum is currently `0.2.7`.

After you install that version, do the following so that all tools that Vinum use get installed:
```bash
    aftman install
```
### Running Tests
The tool responsible for running tests is `Lune`, which if you take a look at the installed tools, you would find it.

Running tests is very easy, all what you need to do is just:
```bash
    lune runTests
```

After you paste that into your CI program, a nicely formatted message will appear.

### Running Benchmarks
Unlike running tests, to run Vinum's benchmarks, you need to use Roblox Studio.

To start running the benchmarks, `rojo build` the `dev.project.json` project file, and then proceed to start a play-test session. After some time, you will see a message printed in the output that contains the info for the benchmarks' results.