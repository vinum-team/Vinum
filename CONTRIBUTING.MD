# Contribution
All contribution to Vinum is highly welcomed. However, to ensure clarity and that nobody's time is wasted here, we enforce a contribution guideline.

## Guidelines

### Bug Reporting
Vinum is a new and immature library, as such, bugs are expected to arise. Read this to learn more about how to report them effectively to the Vinum Team.

Before opening an issue, make sure all of the following is met:
* **You are the first one to report it**. To ensure that, you should check both *clsoed* and *opened* issues. 
* **If a new variant of a bug was introduced after the original one was fixed**, it's best to open a new issue.
* **When opening a new issue**, the title should be ***simple and sensible***, with a summary of as much relevant information as possible in addition to simple reproduction steps with a .rbxl file.
* **When a fix has been merged** (and verified to work) onto the `master` branch of Vinum, the issue will be closed.
* **Please be patient**, as the maintainer team and contributors are volunteers. Bumping issues with `new updates` doesn't help with this.

### Feature Requests
While we work to make Vinum packed with features that satisfy universal cases, some slip away. Read this to learn more about how to suggest new features to the Vinum Team.

Before opening an issue, make sure all of the following is met:
* **You are the first one to suggest it**. To ensure that, you should check both *closed* and *opened* issues. It's possible your feature was rejected.
* **If you do think the issue shouldn't be rejected and have a strong reason behind that**, you should always add your thoughts to the *existing* issue.
* **When opening an issue**, the title should be ***simple and sensible***, with an issue body that explains why a feature should be added, and who it would help, when it would and why.
* As long as it's not the main focus, **API design suggestions are allowed**.
* Almost all feature requests do have a valid concern, but **it's certianly possible that it needs work to design an API that matches Vinum's current public API**.
* **When an implementation has been merged** into `master`, the issue will be closed.
* **Your feature should adopt a declarative mindset** so that users shouldn't depend on *imparative* code that depends on execution order.
* **Guide the users of the feature towards optimal and maintainable code**. This also means that mistakes by the developer are easy to spot. In addition, over engineering isn't welcomed.

## Repo Management

### Issue Phases
1. When an issue is created, its phase is `discussion` right away. This means that the issue is still being evaluated.
2. After the `discussion` phase, the issue is either rejected and enter the `rejected` phase, or accepted and enter the `designing` phase where a solution will be designed.
3. When the solution is finally designed, the issue will enter the `approved` phase, where it waits for the said solution to merge into the `master` branch so that it can be closed. 

### Commit Messages
Vinum adheres to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.4/#specification) spec alongside a few different types and scopes.

#### Types
* fix - A code change that fixes a bug.
* feat - A code change that implements a feature.
* chore - Changes to our tooling and external dependency updates.
* docs - Documentation only changes
* perf - A code change that improves performance.
* refactor - A code change that doesn't fix a bug or adds a new feature.
* tests - Adds missing tests or correcting existing ones.
* bench - Adds missing benchmarks or correcting existing ones.

#### Scopes
* object - Changes in relation to Vinum's state objects' code.
* internal - Changes in relation to Vinum's internal systems such as the dependency system.
* meta - Changes in relation to any non-code component of the repo.

## Development Workflow