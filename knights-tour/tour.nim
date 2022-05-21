import sets, strformat

type
    Loc = tuple
        x: int
        y: int
    Square = object
        moves: HashSet[Loc]
        loc: Loc


proc dummy(): Square =
    let moves = [(0, 0), (0, 1), (0, 2),
                 (1, 0), (1, 1), (1, 2),
                 (2, 0), (2, 1), (2, 2)]
    result = Square(moves: toHashSet(moves), loc: (-1, -1))


proc candidates(loc: Loc, dim: int): HashSet[Loc] =
    result = initHashSet[Loc]()
    let pot: array[8, Loc] = [(-1,  2), (1,  2),
                              (-2,  1), (2,  1),
                              (-2, -1), (2, -1),
                              (-1, -2), (1, -2)]

    for (x, y) in pot:
        if ((loc.x - x >= 0 and loc.x - x < dim) and 
            (loc.y - y >= 0 and loc.y - y < dim)):
            result.incl((loc.x - x, loc.y - y))


# Output
# -----------------------
proc printMove(square: Square, visited: seq[Loc], dim: int): void =
    for x in 0 ..< dim:
        for y in 0 ..< dim:
            stdout.write(
                if square.loc == (x, y):
                    " x "
                elif square.moves.contains((x, y)):
                    " m "
                elif visited.contains((x, y)):
                    " v "
                else:
                    " o "
            )
        stdout.write("\n")

proc printTour(tour: seq[Square], dim: int): void =
    var visited: seq[Loc] = @[]
    for move in tour:
        printMove(move, visited, dim)
        visited.add(move.loc)
        discard readLine(stdin)
   
# Algorithm
# -----------------------
proc warnsdorf(dim: int, start: Loc): seq[Square] =
    var board: seq[seq[Square]] = newSeq[seq[Square]](dim)

    for row in 0 ..< dim:
        board[row] = newSeq[Square](dim)
        for col in 0 ..< dim:
            board[row][col] = Square(
                moves: candidates((col, row), dim),
                loc: (col, row)
            )

    result = @[]
    var curr = board[start.x][start.y]
    while len(curr.moves) > 0:
        var best = dummy()
        for jump in curr.moves:
            board[jump.y][jump.x].moves.excl(curr.loc)
            var square = board[jump.y][jump.x]
            if len(square.moves) < len(best.moves): best = square
        result.add(curr)
        curr = best

let tour = warnsdorf(8, (0, 0))
printTour(tour, 8)
