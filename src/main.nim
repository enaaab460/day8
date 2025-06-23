include lib

when isMainModule:
    let input = getInput("input/puzzle.txt")
    let antennas = readAntennas(input)
    let grid = getGridDimensions(input)
    var antinodes = newSeq[Coord]()
    # for freq, locs in antennas:
