import strutils
import strformat
import std/enumerate
import std/sequtils
import tables
import sets
import threadpool
import locks

type 
    Coord = object
        x, y: int
    Freq = char
    GroupedAntennas = Table[Freq, seq[Coord]]
    GuardedSeq = object
        v: seq[Coord]
        l: Lock

# setMaxPoolSize(4)

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

func getAllAntinodes(antennas: GroupedAntennas, grid: Coord): HashSet[Coord] =
    for freq, locs in antennas:
        for loc in locs:
            let otherLocs = locs.filterIt(it != loc)
            for otherLoc in otherLocs:
                let antinode = getAntinode(loc, otherLoc)
                if inGrid(antinode, grid):
                    result.incl(antinode)

func getAllAntinodes2(antennas: GroupedAntennas, grid: Coord): HashSet[Coord] =
    for freq, locs in antennas:
        for loc in locs:
            let otherLocs = locs.filterIt(it != loc)
            for otherLoc in otherLocs:
                result.incl(otherLoc)
                var antinode = getAntinode(loc, otherLoc)
                var nextNode = otherLoc
                var nextNode2 = antinode
                var tempNode: Coord
                while true:
                    if inGrid(nextNode2, grid):
                        result.incl(nextNode2)
                        tempNode = nextNode2
                        nextNode2 = getAntinode(nextNode, nextNode2)
                        nextNode = tempNode
                    else: break

template guardedSeqAdd(loc: Coord, guardedSeq: ptr GuardedSeq)=
    withLock(guardedSeq.l):
        guardedSeq.v.add(loc)
    # debugecho guardedSeq.v

func threadworker(locs: seq[Coord], loc: Coord,grid: Coord, guardedSeq: ptr GuardedSeq)=
# func threadworker(locs: ptr seq[Coord], loc: Coord,grid: Coord, guardedSeq: ref GuardedSeq)=
    var antinode, nextNode, nextNode2, tempNode: Coord
    # for otherLoc in locs[]:
    for otherLoc in locs:
        if otherLoc == loc: continue
        # var tempAdd = newSeq[Coord]()
        # tempAdd.add(otherLoc)
        guardedSeqAdd(otherLoc, guardedSeq)
        antinode = getAntinode(loc, otherLoc)
        nextNode = otherLoc
        nextNode2 = antinode
        while true:
            if inGrid(nextNode2, grid):
                guardedSeqAdd(nextNode2, guardedSeq)
                # tempAdd.add(nextNode2)
                tempNode = nextNode2
                nextNode2 = getAntinode(nextNode, nextNode2)
                nextNode = tempNode
            else: break
        # withLock(guardedSeq.l):
        #     for coord in tempAdd:
        #         guardedSeq.v.add(coord)

proc getAllAntinodes2multi(antennas: GroupedAntennas, grid: Coord): HashSet[Coord] =
    # var guardedSeq = new GuardedSeq
    var guardedSeq = GuardedSeq()
    guardedSeq.l.initLock()
    # for freq, locs in antennas:
    for locs in antennas.values:
        let locsPtr = locs.addr
        # echo &"{locsPtr.repr=}"
        for loc in locs:
            # spawn threadworker(locsPtr, loc, grid, guardedSeq)
            spawn threadworker(locs, loc, grid, guardedSeq.addr)
    sync()
    withLock(guardedSeq.l):
        return toHashSet(guardedSeq.v)