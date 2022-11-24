<img align = "left" width = 300 src="gh-assets/Banner@svg.svg">

<br><br><br><br>
An ultra-fast multi-paradigm and modern reactive state management library with a scalable interface.  

## Features
* **Multi-paradigm: Self-Contained and Centralized**: In Vinum, you can have centralized state in objects known as `Groups`, or self-contained in objects such as `Hold` - all while providing consistent integration between the two.
* **Ultra Fast**: Vinum's `graph`ing system is incredibly fast, therefore, dependency management has never been faster. Additionally, all provided objects are optimized to be as fast as possible. In our benchmarks (see `benchmarks`), the performance of Vinum was ~1.5us - beating all other known state management libraries out there.
* **Balance In Strictness & Flexibility**: Every Vinum object you would use requires a function that allows you to drop updates or to allow them, and to do any middleware needed - although output alteration isn't allowed and will never be.
* **Simple, and Declarative Gate**: State management in Vinum is beautifully simple and scalable - no boilerplate code for implementing a simple feature!
* **Dependencies? Never heard of em**: You would never worry again about how managing dependencies - all of that is abstracted away!

## Why Speed?

Speed in state management should be optimal, and while other state management libraries often do a great job at maintaining optimal performance, top-tier performance isn't a concern to them.

Vinum is built on the philosophy that user code should be the performance bottleneck so it is easier for them to optimize without forking the library.

That's similar to a chain, the weakest part is what determines the strength of the whole body, however strengthening it is easier than strengthening a chain that is mostly made by weak parts.

## Why Centralized State?

Despite how managing "Centralized" state was confusing with Rodux, it is actually simple, and has its own usecases regardless of what you think of it.

Often times, we need to have some sort of a "centralized-state-container" for our needs, perhaps a container to hold all the related state about our character - this ensures that we have a single source of truth when we want to know what x's value is, without searching through different DataModels that aren't guaranteed to have any relation with the other.

The good part in Vinum is that it doesn't force you into using centralized/self-containing state, their tools are there, and they have amazing integration between them.