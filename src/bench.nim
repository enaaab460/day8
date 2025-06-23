import benchy
include lib

let input = getInput("input/puzzle.txt")
let antennas = readAntennas(input)
let grid = getGridDimensions(input)

timeit "level1":
    discard getAllAntinodes(antennas, grid)

timeit "level2":
    discard getAllAntinodes2(antennas, grid)

timeit "level2 multicore":
    discard getAllAntinodes2multi(antennas, grid)