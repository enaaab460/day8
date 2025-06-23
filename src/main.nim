import strutils
import std/enumerate
import std/tables

type 
    Coord = object
        x, y: int
    Freq = char
    Antenna = object
        freq: Freq
        loc: Coord
    # GroupedAntennas = Table[Freq, seq[Antenna]]
    GroupedAntennas = Table[Freq, seq[Coord]]

proc getInput*(filename: string): string =
    result = readFile(filename)
    result.stripLineEnd()

proc getGridDimensions*(input: string): Coord =
    let lines = input.splitLines()
    result = Coord(x: lines[0].len, y: lines.len)

proc readAntennas*(input: string): GroupedAntennas =
    for y,line in enumerate(input.splitLines()):
        for x in 0..line.high:
            let freq:Freq = line[x]
            if ['.', '#'].contains(freq):
                continue
            result.mgetOrPut(freq, @[]).add(Coord(x: x, y: y))

when isMainModule:
    let input = getInput("input/puzzle.txt")
    echo input