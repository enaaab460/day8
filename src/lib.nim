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
    GroupedAntennas = Table[Freq, seq[Coord]]

proc getInput(filename: string): string =
    result = readFile(filename)
    result.stripLineEnd()

func getGridDimensions(input: string): Coord =
    let lines = input.splitLines()
    result = Coord(x: lines[0].len, y: lines.len)

func inGrid(coord: Coord, grid: Coord): bool =
    coord.x >= 0 and coord.x < grid.x and coord.y >= 0 and coord.y < grid.y

func `+`(coord1: Coord, coord2: Coord): Coord =
    Coord(x: coord1.x + coord2.x, y: coord1.y + coord2.y)

func `-`(coord1: Coord, coord2: Coord): Coord =
    Coord(x: coord1.x - coord2.x, y: coord1.y - coord2.y)

func `*`(coord1: Coord, multiplier: int): Coord =
    Coord(x: coord1.x * multiplier, y: coord1.y * multiplier)

func getAntinode(coord1: Coord, coord2: Coord): Coord =
    let diff = coord1 - coord2
    result = coord1 - (diff * 2)

proc readAntennas(input: string): GroupedAntennas =
    for y,line in enumerate(input.splitLines()):
        for x in 0..line.high:
            let freq:Freq = line[x]
            if ['.', '#'].contains(freq):
                continue
            result.mgetOrPut(freq, @[]).add(Coord(x: x, y: y))