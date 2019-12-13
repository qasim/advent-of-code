import sequtils, sets, strutils, sugar

type LineInstruction = tuple[direction: char, units: int]
type Coordinate = tuple[x: int, y: int]

proc manhattanDistance(intersection: Coordinate): int =
  return abs(intersection.x) + abs(intersection.y)

proc closestIntersection(coordinateSet1: HashSet[Coordinate], coordinateSet2: HashSet[Coordinate]): Coordinate =
  var intersections = intersection(coordinateSet1, coordinateSet2)
  result = intersections.pop()

  for intersection in intersections.items:
    if manhattanDistance(intersection) < manhattanDistance(result):
      result = intersection

proc coordinateSet(instructions: seq[LineInstruction]): HashSet[Coordinate] =
  var currentCoordinate: Coordinate = (0, 0)

  for instruction in instructions:
    var nextCoordinate: Coordinate = (0, 0)

    case instruction.direction:
      of 'L':
        nextCoordinate = (currentCoordinate.x - instruction.units, currentCoordinate.y)
        for x in nextCoordinate.x .. currentCoordinate.x:
          result.incl((x, currentCoordinate.y))

      of 'R':
        nextCoordinate = (currentCoordinate.x + instruction.units, currentCoordinate.y)
        for x in currentCoordinate.x .. nextCoordinate.x:
          result.incl((x, currentCoordinate.y))

      of 'D':
        nextCoordinate = (currentCoordinate.x, currentCoordinate.y - instruction.units)
        for y in nextCoordinate.y .. currentCoordinate.y:
          result.incl((currentCoordinate.x, y))

      of 'U':
        nextCoordinate = (currentCoordinate.x, currentCoordinate.y + instruction.units)
        for y in currentCoordinate.y .. nextCoordinate.y:
          result.incl((currentCoordinate.x, y))

      else:
        echo "Something went wrong"
        quit(1)

    currentCoordinate = nextCoordinate

  # "While the wires do technically cross right at the central port where they both start,
  # this point does not count"
  result.excl((0, 0))

proc main() =
  let inputFile = open("input.txt")
  defer: inputFile.close()

  let inputLine1 = inputFile.readLine()
  let instructions1 = map(inputLine1.split(","), (x: string) -> LineInstruction => (x[0], parseInt(x[1..^1])))
  let coordinateSet1 = coordinateSet(instructions1)

  let inputLine2 = inputFile.readLine()
  let instructions2 = map(inputLine2.split(","), (x: string) -> LineInstruction => (x[0], parseInt(x[1..^1])))
  let coordinateSet2 = coordinateSet(instructions2)

  let closestIntersection = closestIntersection(coordinateSet1, coordinateSet2)
  echo manhattanDistance(closestIntersection)

main()
