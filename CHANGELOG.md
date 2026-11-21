# Changelog

All notable changes to CppLuau-Lib are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versioning follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Runtime Interface contracts and nested Namespace scopes.
- Optional, Result, Pair, Tuple, Variant, and Reference value utilities.
- Array, Vector, Deque, Stack, Queue, PriorityQueue, Map, and Set containers.
- Array Algorithms, Numeric algorithms, and Iterator helpers.
- Functional composition and callback adapters.
- Scope cleanup, String, StringBuilder, Math, and Type utilities.
- TestEZ specs and API documentation for the expanded module set.
- Container usage examples.

### Changed
- Expanded the public entry point to export all implemented modules.
- Reworked the README and project instructions to cover the broader library.
- Vector resizing requires an explicit fill value when growing.
- Deque uses a circular buffer; PriorityQueue uses a binary heap.
