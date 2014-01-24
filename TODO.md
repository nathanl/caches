# TODO

- Fix performance problems in LRU - see below
- Add "least used" cache class
- Use some flavor of linked list (doubly-linked?) with direct references to nodes so that LU and LRU can have O(1) re-arrangement and dropping of keys.
- Add Travis CI testing
- Ride a skateboard and, simultaneously, shoot a potato gun

# LRU Brainstorming

Currently we track the order of key usage in an array. Moving a key to the front is O(N). A doubly linked list could do this as O(1).
However, we also need to be able to get from the data store to a particular key

## Structures

- keylist: Linked list of keys. Last one will be dropped if necessary. Rearrange as keys are used.
- datahash: hash like '{foo: ['bar', pointer_to_list_node]}'.

## Flow

- Writes
  - See if the hash has the key. If not, we're inserting.
    - Insert:
      - Put the key on the front of the linked list
      - Get back a pointer to that node
      - Add 'key => [val, pointer]' to the hash
    - Update
      - Simply update the val in the hash tuple. (update != usage; doesn't change readiness for dropping)
- Reads
  - See if the hash has the key. If not, return nil.
  - Hash has key: go and get val. Hang on to it.
  - Use node reference to tell linked list to move it to the front.
  - Return val
