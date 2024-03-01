# Changelogs

Any changes that hold a value should be listed here under the Version that they will be released under.
## Unreleased 
### Added
* Added the ability for Deriveds to cache optional arguments supplied by the user. This helps with cases where building more complex state objects on top of Deriveds (such as Maps) requires caching some essential data to help Luau better optimise our code.
* Re-added `Vinum.Version` table.
* `Track` now returns an `untrack` function used for disconnecting functions.
### Changed
* Removed RNode and related types and instead implemented a generic `ReactiveObject` type that all state objects adhere to. This lowers the memory usage and generally decreases the processing time.
* Simplified iListeners to simple functions.
* Renamed `On` operator to `Track`.
### Removed
* Removed Selects (and additionally, the hardcoded support for it in all other places), in preparation for new tools to help with state centralization.

## V0.4.2
* Exposes the `DerivedScope`.
## V0.4.1
* Fixed a bug in Select where it would not init its value until the next update.
* Some internal changes in Derived.luau and Select.luau.
## V0.4
* Changes are untracked until 1.0.0.
## V0.3
* Everything is completely refined, and changed since the last version. Everything below is just a "summary" of the new major features.
* Async Operations are now supported.
* Mirror, Reflect, Match and other similar objects are now moved into a single object.
* Observe is now changed to listener, and now has the ability to remember old state.
* Ability to cancel dependency tree recalcuation is now present.
* Groups are now removed, and now a `KeyOf` object is present to caputre a "selection" of a state object that holds a table.
* A new dependency tree simplifier.
## V0.2
* `Vinum.JustOk` was renamed to `Vinum.AlwaysTrue` for a more descriptive API for begineers
* `Observe:onBind`, which fires the provided function, and then returns a connection disconnector.
* `Vinum.Mirror` object, which is used for directly mirroring Objects' values, as opposed to `Vinum.Match`, which perform a computation instead.
* `Vinum.Reflect` object, which is used directly to mirror a specific object's value. Useful for creating readonly clones of a state object.
* `Vinum.Wrap` object, which is used to derive state objects from a luau-pure signal/RBXScriptSignal.
* A fix for Match, which is to fix an error that can occur when working with self-contained `Vinum.Group` keys.
* `Vinum.Record` object, which is used to store "records" of a specific object's value. 
* `Vinum.Version`  table, which is used to identify the version that this module is built on
* `Vinum.Destroy` function, which enables you to destroy state objects.
## V0.1
Initial Release.