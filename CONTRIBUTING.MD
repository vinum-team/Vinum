# Contribution
All contribution to Vinum is highly welcomed. However, to ensure clarity and that nobody's time is wasted here, we enforce a contribution guideline.

## Guidelines
### Features

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