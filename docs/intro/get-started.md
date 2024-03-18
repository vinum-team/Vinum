# Get Started
Welcome to the Vinum documentation site! With the help of this site, you will learn how to manage state using Vinum, even if you haven't used the library before.


::: warning

Bear in mind that Vinum is currently still in development, so API stability is not a concern at the moment.
:::

## Installing Vinum
Vinum is distrbuted using [Wally](https://wally.run) under the `plothan` scope, as such, you are required to use Wally to install Vinum.

::: info

When Vinum reaches 1.0.0, it's expected that we will start distrbuting rbxms alongisde wally releases
:::

When you finished installing wally, add the following to your `wally.toml`'s `[dependencies]` field:
```toml
vinum = "plothan/vinum@0.5.0"
```