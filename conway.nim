import std/os
import std/random
import std/strformat
import std/terminal
import std/parseutils

# Conway's game of life

type
  Cell = object
    live: bool
    neighbors: uint8
  Board = seq[seq[Cell]]

proc toString(board: Board): string =
  for row in board:
    for col in row:
      result.add(if col.live: '*' else: ' ')
    result.add('\n')

proc updateNeighbors(board: Board): Board =
  result = board
  for row in 0 ..< len(board):
    for col in 0 ..< len(board[row]):
      let prevRow = if row - 1 >= 0: row - 1 else: len(board) - 1
      let nextRow = (row + 1) mod (len(board) - 1)
      let prevCol = if col - 1 >= 0: col - 1 else: len(board[row]) - 1
      let nextCol = (col + 1) mod (len(board[row]) - 1)

      result[row][col].neighbors = 0
      for adjacentRow in [prevRow, row, nextRow]:
        for adjacentCol in [prevcol, col, nextCol]:
          if result[adjacentRow][adjacentCol].live and 
            not (adjacentRow == row and adjacentCol == col):
            inc result[row][col].neighbors

proc initializeBoard(xDim: int, yDim: int, percentage: int): Board =
  result = @[]
  for row in 0 ..< xDim:
    result.add(@[])
    for col in 0 ..< yDim:
      let num = rand(99)
      result[row].add(Cell(live: num < percentage, neighbors: 0))

  result = updateNeighbors(result)

# 1. Any live cell with fewer than two live neighbors dies
# 2. Any live cell with two or three live neighbours lives on to the next generation
# 3. Any live cell with more than three live neighbours dies as if by overpopulation
# 4. Any dead cell with exactly three live neighbours becomes a live cell
proc simulateStep(board: Board): Board =
  result = board
  for r, row in board:
    for c, col in row:
      if col.live:
        result[r][c].live = col.neighbors == 2 or col.neighbors == 3
      else:
        result[r][c].live = col.neighbors == 3
  
  result = updateNeighbors(result)
  
proc simulate(x = 40, y = 40, steps = 100, density = 20): void =
  var board = initializeBoard(x, y, density)

  for step in 1 .. steps:
    echo board.toString()
    board = simulateStep(board)
    sleep(150)

randomize()
simulate(terminalHeight(), terminalWidth(), 1000, 50)
