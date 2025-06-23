include lib
import nimprof

let input = getInput("input/puzzle.txt")
let antennas = readAntennas(input)
let grid = getGridDimensions(input)

discard getAllAntinodes2multi(antennas, grid)