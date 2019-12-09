import sequtils, strutils, sugar, tables, bigints

type Instruction = tuple[
  opcode: int,
  mode1: int,
  mode2: int,
  mode3: int
]

proc instruction(integer: BigInt): Instruction =
  let integerString = $integer

  if integerString.len == 1 or integerString.len == 2:
    return (
      opcode: parseInt(integerString),
      mode1: 0,
      mode2: 0,
      mode3: 0
    )

  elif integerString.len == 3:
    return (
      opcode: parseInt(integerString[1..^1]),
      mode1: parseInt($integerString[0]),
      mode2: 0,
      mode3: 0
    )

  elif integerString.len == 4:
    return (
      opcode: parseInt(integerString[2..^1]),
      mode1: parseInt($integerString[1]),
      mode2: parseInt($integerString[0]),
      mode3: 0
    )

  elif integerString.len == 5:
    return (
      opcode: parseInt(integerString[3..^1]),
      mode1: parseInt($integerString[2]),
      mode2: parseInt($integerString[1]),
      mode3: parseInt($integerString[0])
    )

  echo "Something went wrong"
  quit(1)

proc `[]`(t: Table[BigInt, BigInt]; key: BigInt): BigInt =
  return t.getOrDefault(key)

proc executeIntcode(integers: var Table[BigInt, BigInt], input: BigInt, position: BigInt, relativeBase: BigInt): int =
  var position = position
  var relativeBase = relativeBase

  while true:
    let instruction = instruction(integers[position])
    case instruction.opcode:
      of 1:
        var parameter1: BigInt
        case instruction.mode1:
          of 0:
            parameter1 = integers[integers[position + 1]]
          of 1:
            parameter1 = integers[position + 1]
          of 2:
            parameter1 = integers[relativeBase + integers[position + 1]]
          else:
            echo "Something went wrong"
            quit(1)

        var parameter2: BigInt
        case instruction.mode2:
          of 0:
            parameter2 = integers[integers[position + 2]]
          of 1:
            parameter2 = integers[position + 2]
          of 2:
            parameter2 = integers[relativeBase + integers[position + 2]]
          else:
            echo "Something went wrong"
            quit(1)

        case instruction.mode3:
          of 0:
            integers[integers[position + 3]] = parameter1 + parameter2
          of 2:
            integers[relativeBase + integers[position + 3]] = parameter1 + parameter2
          else:
            echo "Something went wrong"
            quit(1)

        position = position + 4

      of 2:
        var parameter1: BigInt
        case instruction.mode1:
          of 0:
            parameter1 = integers[integers[position + 1]]
          of 1:
            parameter1 = integers[position + 1]
          of 2:
            parameter1 = integers[relativeBase + integers[position + 1]]
          else:
            echo "Something went wrong"
            quit(1)

        var parameter2: BigInt
        case instruction.mode2:
          of 0:
            parameter2 = integers[integers[position + 2]]
          of 1:
            parameter2 = integers[position + 2]
          of 2:
            parameter2 = integers[relativeBase + integers[position + 2]]
          else:
            echo "Something went wrong"
            quit(1)

        case instruction.mode3:
          of 0:
            integers[integers[position + 3]] = parameter1 * parameter2
          of 2:
            integers[relativeBase + integers[position + 3]] = parameter1 * parameter2
          else:
            echo "Something went wrong"
            quit(1)

        position = position + 4

      of 3:
        case instruction.mode1:
          of 0:
            integers[integers[position + 1]] = input
          of 2:
            integers[relativeBase + integers[position + 1]] = input
          else:
            echo "Something went wrong"
            quit(1)

        position = position + 2

      of 4:
        var parameter1: BigInt
        case instruction.mode1:
          of 0:
            parameter1 = integers[integers[position + 1]]
          of 1:
            parameter1 = integers[position + 1]
          of 2:
            parameter1 = integers[relativeBase + integers[position + 1]]
          else:
            echo "Something went wrong"
            quit(1)

        echo parameter1
        position = position + 2

      of 5:
        var parameter1: BigInt
        case instruction.mode1:
          of 0:
            parameter1 = integers[integers[position + 1]]
          of 1:
            parameter1 = integers[position + 1]
          of 2:
            parameter1 = integers[relativeBase + integers[position + 1]]
          else:
            echo "Something went wrong"
            quit(1)

        var parameter2: BigInt
        case instruction.mode2:
          of 0:
            parameter2 = integers[integers[position + 2]]
          of 1:
            parameter2 = integers[position + 2]
          of 2:
            parameter2 = integers[relativeBase + integers[position + 2]]
          else:
            echo "Something went wrong"
            quit(1)

        if parameter1 != 0:
          position = parameter2
        else:
          position = position + 3

      of 6:
        var parameter1: BigInt
        case instruction.mode1:
          of 0:
            parameter1 = integers[integers[position + 1]]
          of 1:
            parameter1 = integers[position + 1]
          of 2:
            parameter1 = integers[relativeBase + integers[position + 1]]
          else:
            echo "Something went wrong"
            quit(1)

        var parameter2: BigInt
        case instruction.mode2:
          of 0:
            parameter2 = integers[integers[position + 2]]
          of 1:
            parameter2 = integers[position + 2]
          of 2:
            parameter2 = integers[relativeBase + integers[position + 2]]
          else:
            echo "Something went wrong"
            quit(1)

        if parameter1 == 0:
          position = parameter2
        else:
          position = position + 3

      of 7:
        var parameter1: BigInt
        case instruction.mode1:
          of 0:
            parameter1 = integers[integers[position + 1]]
          of 1:
            parameter1 = integers[position + 1]
          of 2:
            parameter1 = integers[relativeBase + integers[position + 1]]
          else:
            echo "Something went wrong"
            quit(1)

        var parameter2: BigInt
        case instruction.mode2:
          of 0:
            parameter2 = integers[integers[position + 2]]
          of 1:
            parameter2 = integers[position + 2]
          of 2:
            parameter2 = integers[relativeBase + integers[position + 2]]
          else:
            echo "Something went wrong"
            quit(1)

        case instruction.mode3:
          of 0:
            if parameter1 < parameter2:
              integers[integers[position + 3]] = 1.initBigInt
            else:
              integers[integers[position + 3]] = 0.initBigInt
          of 2:
            if parameter1 < parameter2:
              integers[relativeBase + integers[position + 3]] = 1.initBigInt
            else:
              integers[relativeBase + integers[position + 3]] = 0.initBigInt
          else:
            echo "Something went wrong"
            quit(1)

        position = position + 4

      of 8:
        var parameter1: BigInt
        case instruction.mode1:
          of 0:
            parameter1 = integers[integers[position + 1]]
          of 1:
            parameter1 = integers[position + 1]
          of 2:
            parameter1 = integers[relativeBase + integers[position + 1]]
          else:
            echo "Something went wrong"
            quit(1)

        var parameter2: BigInt
        case instruction.mode2:
          of 0:
            parameter2 = integers[integers[position + 2]]
          of 1:
            parameter2 = integers[position + 2]
          of 2:
            parameter2 = integers[relativeBase + integers[position + 2]]
          else:
            echo "Something went wrong"
            quit(1)

        case instruction.mode3:
          of 0:
            if parameter1 == parameter2:
              integers[integers[position + 3]] = 1.initBigInt
            else:
              integers[integers[position + 3]] = 0.initBigInt
          of 2:
            if parameter1 == parameter2:
              integers[relativeBase + integers[position + 3]] = 1.initBigInt
            else:
              integers[relativeBase + integers[position + 3]] = 0.initBigInt
          else:
            echo "Something went wrong"
            quit(1)

        position = position + 4

      of 9:
        var parameter1: BigInt
        case instruction.mode1:
          of 0:
            parameter1 = integers[integers[position + 1]]
          of 1:
            parameter1 = integers[position + 1]
          of 2:
            parameter1 = integers[relativeBase + integers[position + 1]]
          else:
            echo "Something went wrong"
            quit(1)

        relativeBase = relativeBase + parameter1
        position = position + 2

      of 99:
        quit(0)

      else:
        echo "Something went wrong"
        quit(1)

proc executeIntcode(integers: seq[BigInt], input: BigInt): int =
  var integersTable = initTable[BigInt, BigInt]()
  for i, integer in integers:
    integersTable[i.initBigInt] = integer

  return executeIntcode(integersTable, input, 0.initBigInt, 0.initBigInt)

proc main() =
  let inputFile = open("input.txt")
  let input = inputFile.readLine()
  inputFile.close()

  let integers = map(input.split(","), (x: string) => parseBiggestInt(x).initBigInt)
  echo executeIntcode(integers, 2.initBigInt)

main()
