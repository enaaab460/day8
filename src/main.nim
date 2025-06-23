include lib

when isMainModule:
    let input = getInput("input/puzzle.txt")
    let antennas = readAntennas(input)
    let grid = getGridDimensions(input)
    let antinodes = getAllAntinodes(antennas, grid)
    echo antinodes.len
    # echo antinodes
    let antinodes2 = getAllAntinodes2(antennas, grid)
    echo antinodes2.len
    let antinodes3 = getAllAntinodes2multi(antennas, grid)
    echo antinodes3.len
    # echo antinodes2