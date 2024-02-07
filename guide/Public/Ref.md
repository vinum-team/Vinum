# Refs

Refs are simple structs that wrap other state structs in a specific format. These are "references" which mean any sort of writing operator (Write and Batch) don't work on them.

## Lists of Allowed Operators
* On
* Read
* Use (Learn more about this operator by reading Deriveds.md)

## Usage in other State structs
All state structs that concern themselves with working with other state structs (Maps, Deriveds, Selects) also accept Refs.
