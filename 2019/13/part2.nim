import sequtils, strutils, sugar, tables

type
  IntcodeInstruction = object
    opcode, mode1, mode2, mode3: int

type
  Coordinate = object
    x, y: BiggestInt

type
  ArcadeInstruction = object
    coordinate: Coordinate
    tileId: BiggestInt

proc `[]`(t: Table[BiggestInt, BiggestInt]; key: BiggestInt): BiggestInt =
  return t.getOrDefault(key)

proc instruction(integer: BiggestInt): IntcodeInstruction =
  let integerString = align($integer, 5, '0')
  return IntcodeInstruction(
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

proc main() =
  let inputFile = open("input.txt")
  let rawIntcodeProgram = inputFile.readLine()
  inputFile.close()

  let integers = map(rawIntcodeProgram.split(","), (x: string) => parseBiggestInt(x))
  var integersTable = initTable[BiggestInt, BiggestInt]()
  for i, integer in integers:
    integersTable[i] = integer

  # Insert quarters
  integersTable[0] = 2

  var input: BiggestInt = 0
  var position: BiggestInt = 0
  var relativeBase: BiggestInt = 0

  var paddle: Coordinate
  var ball: Coordinate
  var score: BiggestInt
  var rawInstruction: seq[BiggestInt]

  for output in intcode(integersTable, input, position, relativeBase):
    rawInstruction.add(output)
    if rawInstruction.len == 3:
      defer: rawInstruction.setLen(0)

      let instruction = ArcadeInstruction(
        coordinate: Coordinate(
          x: rawInstruction[0],
          y: rawInstruction[1]
        ),
        tileId: rawInstruction[2])

      if instruction.coordinate == Coordinate(x: -1, y: 0):
        score = instruction.tileId
      elif instruction.tileId == 3:
        paddle = instruction.coordinate
      elif instruction.tileId == 4:
        ball = instruction.coordinate

      if paddle.x > ball.x:
        input = -1
      elif paddle.x < ball.x:
        input = 1
      else:
        input = 0

  echo score

main()
