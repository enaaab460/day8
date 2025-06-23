import unittest2
import strformat
include lib

suite "process input":
    test "antennas":
        let input = getInput("input/example4.txt")
        let antennas = readAntennas(input)
        check $antennas == "{'A': @[(x: 6, y: 5), (x: 8, y: 8), (x: 9, y: 9)], '0': @[(x: 8, y: 1), (x: 5, y: 2), (x: 7, y: 3), (x: 4, y: 4)]}"
    
    test "antinodes":
        check getAntinode(Coord(x:8, y:1), Coord(x:5, y:2)) == Coord(x:2, y:3)

    test "all antinodes":
        let input = getInput("input/example4.txt")
        let antennas = readAntennas(input)
        let grid = getGridDimensions(input)
        let antinodes = getAllAntinodes(antennas, grid)
        check antinodes.len == 14
        # echo antinodes

    test "all antinodes 2":
        let input = getInput("input/example5.txt")
        let antennas = readAntennas(input)
        let grid = getGridDimensions(input)
        let antinodes = getAllAntinodes2(antennas, grid)
        check antinodes.len == 9
        # echo antinodes

    test "all antinodes 3":
        let input = getInput("input/example6.txt")
        let antennas = readAntennas(input)
        let grid = getGridDimensions(input)
        let antinodes = getAllAntinodes2(antennas, grid)
        check antinodes.len == 34
        # echo antinodes
