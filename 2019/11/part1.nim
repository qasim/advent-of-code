import sequtils, strutils, sugar, tables

type
  Instruction = tuple[
    opcode: int,
    mode1: int,
    mode2: int,
    mode3: int
  ]

type
  Coordinate = tuple[
    x: int,
    y: int
  ]

type
  Direction = enum
    dUp, dLeft, dDown, dRight

proc `[]`(t: Table[BiggestInt, BiggestInt]; key: BiggestInt): BiggestInt =
  return t.getOrDefault(key)

proc instruction(integer: BiggestInt): Instruction =
  let integerString = align($integer, 5, '0')
  return (
    opcode: parseInt(integerString[3..^1]),
    mode1: parseInt($integerString[2]),
    mode2: parseInt($integerString[1]),
    mode3: parseInt($integerString[0])
  )

proc parameter(integers: var Table[BiggestInt, BiggestInt], position: BiggestInt, relativeBase: BiggestInt, mode: int): BiggestInt =
  case mode:
    of 0:
      result = integers[integers[position]]
    of 1:
      result = integers[position]
    of 2:
      result = integers[relativeBase + integers[position]]
    else:
      echo "Something went wrong"
      quit(1)

proc setParameter(integers: var Table[BiggestInt, BiggestInt], position: BiggestInt, relativeBase: BiggestInt, mode: int, value: BiggestInt) =
  case mode:
    of 0:
      integers[integers[position]] = value
    of 2:
      integers[relativeBase + integers[position]] = value
    else:
      echo "Something went wrong"
      quit(1)

iterator intcode(integers: var Table[BiggestInt, BiggestInt], input: var BiggestInt, position: var BiggestInt, relativeBase: var BiggestInt): BiggestInt =
  while true:
    let instruction = instruction(integers[position])
    case instruction.opcode:
      of 1:
        let parameter1 = integers.parameter(position + 1, relativeBase, instruction.mode1)
        let parameter2 = integers.parameter(position + 2, relativeBase, instruction.mode2)
        integers.setParameter(position + 3, relativeBase, instruction.mode3, parameter1 + parameter2)
        position += 4

      of 2:
        let parameter1 = integers.parameter(position + 1, relativeBase, instruction.mode1)
        let parameter2 = integers.parameter(position + 2, relativeBase, instruction.mode2)
        integers.setParameter(position + 3, relativeBase, instruction.mode3, parameter1 * parameter2)
        position += 4

      of 3:
        integers.setParameter(position + 1, relativeBase, instruction.mode1, input)
        position += 2

      of 4:
        let parameter1 = integers.parameter(position + 1, relativeBase, instruction.mode1)
        position += 2
        yield parameter1

      of 5:
        let parameter1 = integers.parameter(position + 1, relativeBase, instruction.mode1)
        let parameter2 = integers.parameter(position + 2, relativeBase, instruction.mode2)
        if parameter1 != 0:
          position = parameter2
        else:
          position += 3

      of 6:
        let parameter1 = integers.parameter(position + 1, relativeBase, instruction.mode1)
        let parameter2 = integers.parameter(position + 2, relativeBase, instruction.mode2)
        if parameter1 == 0:
          position = parameter2
        else:
          position += 3

      of 7:
        let parameter1 = integers.parameter(position + 1, relativeBase, instruction.mode1)
        let parameter2 = integers.parameter(position + 2, relativeBase, instruction.mode2)
        if parameter1 < parameter2:
          integers.setParameter(position + 3, relativeBase, instruction.mode3, 1)
        else:
          integers.setParameter(position + 3, relativeBase, instruction.mode3, 0)
        position += 4

      of 8:
        let parameter1 = integers.parameter(position + 1, relativeBase, instruction.mode1)
        let parameter2 = integers.parameter(position + 2, relativeBase, instruction.mode2)
        if parameter1 == parameter2:
          integers.setParameter(position + 3, relativeBase, instruction.mode3, 1)
        else:
          integers.setParameter(position + 3, relativeBase, instruction.mode3, 0)
        position += 4

      of 9:
        let parameter1 = integers.parameter(position + 1, relativeBase, instruction.mode1)
        relativeBase += parameter1
        position += 2

      of 99:
        break

      else:
        echo "Something went wrong"
        quit(1)

proc directionAfterTurning(direction: Direction, turn: BiggestInt): Direction =
  if turn == 0:
    case direction:
      of dUp:
        return dLeft
      of dLeft:
        return dDown
      of dDown:
        return dRight
      of dRight:
        return dUp
  else:
    case direction:
      of dUp:
        return dRight
      of dLeft:
        return dUp
      of dDown:
        return dLeft
      of dRight:
        return dDown

proc coordinateAfterMoving(coordinate: Coordinate, direction: Direction): Coordinate =
  case direction:
    of dUp:
      return (x: coordinate.x, y: coordinate.y - 1)
    of dLeft:
      return (x: coordinate.x - 1, y: coordinate.y)
    of dDown:
      return (x: coordinate.x, y: coordinate.y + 1)
    of dRight:
      return (x: coordinate.x + 1, y: coordinate.y)

proc main() =
  let inputFile = open("input.txt")
  let rawIntcodeProgram = inputFile.readLine()
  inputFile.close()

  let integers = map(rawIntcodeProgram.split(","), (x: string) => parseBiggestInt(x))
  var integersTable = initTable[BiggestInt, BiggestInt]()
  for i, integer in integers:
    integersTable[i] = integer

  var input: BiggestInt = 0
  var position: BiggestInt = 0
  var relativeBase: BiggestInt = 0

  var hasSufficientInformation: bool = false
  var colorToPaint: BiggestInt = 0
  var directionToTurn: BiggestInt = 0

  var paintedPanelsTable = initTable[Coordinate, BiggestInt]()
  var currentDirection: Direction = dUp
  var currentCoordinate: Coordinate = (x: 0, y: 0)

  for output in intcode(integersTable, input, position, relativeBase):
    if hasSufficientInformation:
      directionToTurn = output
      hasSufficientInformation = false
    else:
      colorToPaint = output
      hasSufficientInformation = true
      continue

    paintedPanelsTable[currentCoordinate] = colorToPaint

    currentDirection = currentDirection.directionAfterTurning(directionToTurn)
    currentCoordinate = currentCoordinate.coordinateAfterMoving(currentDirection)

    input = paintedPanelsTable.getOrDefault(currentCoordinate)

  echo paintedPanelsTable.len

main()
