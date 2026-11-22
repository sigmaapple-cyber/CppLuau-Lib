# Changelog

All notable changes to CppLuau-Lib are documented here.

## Unreleased

### Added
- Doubly linked List and singly linked ForwardList containers.
- Non-owning array Span and fixed-size BitSet.
- Binary search, stable sorting, merge, and sorted checks.
- Seeded xorshift32 random generator, bit operations, and complex numbers.
- StringView and positional text formatting.
- Clock, Duration, and Timer modules.
- Growable binary Buffer with primitive reads and writes.
- TestEZ coverage for the new data structures and APIs.

### Changed
- Reorganized the public API into Core, Values, Containers, Algorithms, Math, Text, Utility, Time, and Binary namespaces.
- Renamed Map and Set to HashMap and HashSet to describe their hash-table implementation.
- Renamed generic Math and Type modules to Math.Scalar and Utility.TypeInfo.
- Replaced flat public exports with category-based exports.
- Updated guides, examples, and agent instructions for the new layout.
