include lib

let input = getInput("input/puzzle.txt")
let antennas = readAntennas(input)
let grid = getGridDimensions(input)

# for _ in 1..10_000:
    # discard getAllAntinodes2(antennas, grid).len
    # discard getAllAntinodes2(antennas, grid)
discard getAllAntinodes2(antennas, grid)