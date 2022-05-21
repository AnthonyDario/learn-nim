# Notes on the Nim languages

Since I never seem to find what I'm looking for online.

## Tuples
Tuples are equivalent if they have the same values:
```nim
let first  = (1, "hello")
let second = (1, "hello")
let third  = (2, "goodbye")

echo first == second # true
echo first == third  # false
```
