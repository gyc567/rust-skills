---
name: rust-build-and-check
description: "Builds a standard Rust project and runs clippy for linting and suggestions."
compatibility: opencode
metadata:
  audience: rust-developer
  workflow: development
---
## What I do
- I run `cargo check` for a quick compilation check.
- I run `cargo build` to build the project in debug mode.
- I run `cargo clippy` to provide linting and code quality suggestions.

## When to use me
Use this skill when you want to validate a standard Rust crate. This is useful for a quick quality gate before committing code.

**Note:** This skill assumes it's being run in the root directory of a Rust crate that contains a `Cargo.toml` file.
