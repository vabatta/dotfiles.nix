# Task types

Pick one section before step 1. When two fit, take the heavier one.

## Trivial

**Pick when:** the change has no behavior change, or it is a few lines with one obvious form: a typo, a rename, a config value, a version string.

Skip the red-first test. Make the change, run the nearest existing check, and hand it to **review** for one fresh pass with no rounds.

## Bug

**Pick when:** something behaves wrongly and the cause is known. An unknown cause goes to **diagnosing-bugs** first.

The red test reproduces the bug at the seam where it shows up. Fix at the root, and grep for every other instance of the same pattern.

## Feature

**Pick when:** the change adds behavior.

When it adds a module, an interface, or a data shape, run **architect** first and build against its sketch. Each acceptance line gets a test whose name states it.

## Refactor

**Pick when:** the behavior stays the same and the shape changes.

The existing tests are the check, so run them green before you start. Add a characterization test where coverage is thin. Change no behavior and no test assertion.

## Dependency

**Pick when:** adding, removing, or upgrading a package.

Read the changelog between the two versions with **research**, and list the breaking changes the code touches. Upgrade one package per unit. Prove it with the full test suite, not only the nearest test.

## Docs

**Pick when:** only documentation or comments change.

Use **writing**. Make every path, command, and count true against the code at this commit, and run any command the doc shows.
