import main
import unittest2
import strformat
import std/tables

suite "process input":
    test "antennas":
        let input = getInput("input/example4.txt")
        let antennas = readAntennas(input)
        echo $antennas
        check $antennas == "{'A': @[(x: 6, y: 5), (x: 8, y: 8), (x: 9, y: 9)], '0': @[(x: 8, y: 1), (x: 5, y: 2), (x: 7, y: 3), (x: 4, y: 4)]}"
        # check $antennas == "@[(freq: '0', loc: (x: 8, y: 1)), (freq: '0', loc: (x: 5, y: 2)), (freq: '0', loc: (x: 7, y: 3)), (freq: '0', loc: (x: 4, y: 4)), (freq: 'A', loc: (x: 6, y: 5)), (freq: 'A', loc: (x: 8, y: 8)), (freq: 'A', loc: (x: 9, y: 9))]"