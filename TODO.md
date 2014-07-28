# TODO

## General

- Refactor LinkedList
- Add benchmarks: speed (and maybe memory usage), runnable with rake task for all cache classes. Be able to compare over the course of development (eg, version 0.0.1 vs 0.0.3). Maybe output ASCII graphs for fun.
- Add Travis CI testing
- Give all caches a way to manually invalidate a given key. Return nil if it wasn't here and the value if it was.
- Add "least used" cache class
- Define `blank?`, etc on list and caches
- Should TTL keys be renewed by updates? LRU ones aren't. If the cache exists to be read, probably not.
- Ride a skateboard and, simultaneously, shoot a potato gun

## New types

Build LU - Least Used. Expiration criteria is essentially "uses per second" - reads divided by time since write.

Implementation ideas:
  - Passage of time doesn't change ranking of keys; only writing does.
  - Keep a doubly-linked list of keys ordered by usefulness and a reference to the tail for easy dropping
  - When updating a key, be able to quickly compare it with the one ahead of it and swap if it overtook it in rank
  - Normal hash data structure has pointers into linked list segments


## Benchmarks

TTL: Prepopulate instances differing in size by orders of magnitude. Measure N operations of various types. These vary on three axes: read/write, expired/fresh, and update/insert for writes. Output results as graph. Visually confirm that it appears O(1) and is reasonably fast (?) in absolute terms.

LRU: ?
