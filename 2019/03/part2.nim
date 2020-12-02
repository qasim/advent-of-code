import algorithm, sequtils, sets, strutils, sugar

type LineInstruction = tuple[direction: char, units: int]
type Coordinate = tuple[x: int, y: int]

proc intersections(coordinateSeq1: seq[Coordinate], coordinateSeq2: seq[Coordinate]): seq[Coordinate] =
  var coordinateSet1 = initHashSet[Coordinate]()
  for coordinate in coordinateSeq1:
    coordinateSet1.incl(coordinate)
  coordinateSet1.excl((0, 0))

  var coordinateSet2 = initHashSet[Coordinate]()
  for coordinate in coordinateSeq2:
    coordinateSet2.incl(coordinate)
  coordinateSet2.excl((0, 0))

  for coordinate in intersection(coordinateSet1, coordinateSet2).items:
    result.add(coordinate)

proc fewestCombinedSteps(coordinateSeq1: seq[Coordinate], coordinateSeq2: seq[Coordinate]): int =
  let intersections = intersections(coordinateSeq1, coordinateSeq2)

  var combinedSteps: seq[int]
  for intersection in intersections:
    combinedSteps.add(coordinateSeq1.find(intersection) + coordinateSeq2.find(intersection))

  return min(combinedSteps)

proc coordinateSeq(instructions: seq[LineInstruction]): seq[Coordinate] =
  var currentCoordinate: Coordinate = (0, 0)

  for instruction in instructions:
    var nextCoordinate: Coordinate = (0, 0)

    case instruction.direction:
      of 'L':
        nextCoordinate = (currentCoordinate.x - instruction.units, currentCoordinate.y)
        var coordinatesToAdd: seq[Coordinate]
        for x in (nextCoordinate.x + 1) .. currentCoordinate.x:
          coordinatesToAdd.add((x, currentCoordinate.y))
        result.add(coordinatesToAdd.reversed())

      of 'R':
        nextCoordinate = (currentCoordinate.x + instruction.units, currentCoordinate.y)
        for x in currentCoordinate.x .. (nextCoordinate.x - 1):
          result.add((x, currentCoordinate.y))

      of 'D':
        var coordinatesToAdd: seq[Coordinate]
        nextCoordinate = (currentCoordinate.x, currentCoordinate.y - instruction.units)
        for y in (nextCoordinate.y + 1) .. currentCoordinate.y:
          coordinatesToAdd.add((currentCoordinate.x, y))
        result.add(coordinatesToAdd.reversed())

      of 'U':
        nextCoordinate = (currentCoordinate.x, currentCoordinate.y + instruction.units)
        for y in currentCoordinate.y .. (nextCoordinate.y - 1):
          result.add((currentCoordinate.x, y))

      else:
        echo "Something went wrong"
        quit(1)

    currentCoordinate = nextCoordinate

proc main() =
  let inputFile = open("input.txt")
  defer: inputFile.close()

  let inputLine1 = inputFile.readLine()
  let instructions1 = map(inputLine1.split(","), (x: string) -> LineInstruction => (x[0], parseInt(x[1..^1])))
  let coordinateSeq1 = coordinateSeq(instructions1)

  let inputLine2 = inputFile.readLine()
  let instructions2 = map(inputLine2.split(","), (x: string) -> LineInstruction => (x[0], parseInt(x[1..^1])))
  let coordinateSeq2 = coordinateSeq(instructions2)

  let fewestCombinedSteps = fewestCombinedSteps(coordinateSeq1, coordinateSeq2)
  echo fewestCombinedSteps

main()
