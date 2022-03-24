import std/os
import std/strformat
import std/parseutils

var rounds: int
if len(commandLineParams()) < 1:
  rounds = 100
else:
  discard parseInt(commandLineParams()[0], rounds)

var
  a: float = 1
  b: float = 1
  old_a: float = 1

for i in 0 .. rounds:
  old_a = a
  a = a + b
  b = old_a
  echo &"round {i} -- {b}"
