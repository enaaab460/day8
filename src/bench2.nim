import benchy
include lib
# import nimprof

let input = getInput("input/puzzle.txt")
let antennas = readAntennas(input)
let grid = getGridDimensions(input)

timeit "level2 multi":
    discard getAllAntinodes2multi(antennas, grid)