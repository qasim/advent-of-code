import sequtils, strutils, sugar

type Instruction = tuple[
  opcode: int,
  mode1: int,
  mode2: int,
  mode3: int
]

proc instruction(integer: int): Instruction =
  let integerString = intToStr(integer)

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

proc executeIntcode(integers: var seq[int], input: int, position: int): int =
  let instruction = instruction(integers[position])
  var jump: int

  case instruction.opcode:
    of 1:
      var parameter1: int
      if instruction.mode1 == 0:
        parameter1 = integers[integers[position + 1]]
      else:
        parameter1 = integers[position + 1]

      var parameter2: int
      if instruction.mode2 == 0:
        parameter2 = integers[integers[position + 2]]
      else:
        parameter2 = integers[position + 2]

      integers[integers[position + 3]] = parameter1 + parameter2
      jump = 4

    of 2:
      var parameter1: int
      if instruction.mode1 == 0:
        parameter1 = integers[integers[position + 1]]
      else:
        parameter1 = integers[position + 1]

      var parameter2: int
      if instruction.mode2 == 0:
        parameter2 = integers[integers[position + 2]]
      else:
        parameter2 = integers[position + 2]

      integers[integers[position + 3]] = parameter1 * parameter2
      jump = 4

    of 3:
      integers[integers[position + 1]] = input
      jump = 2

    of 4:
      var parameter1: int
      if instruction.mode1 == 0:
        parameter1 = integers[integers[position + 1]]
      else:
        parameter1 = integers[position + 1]

      echo parameter1
      jump = 2

    of 99:
      quit(0)

    else:
      echo "Something went wrong"
      quit(1)

  return executeIntcode(integers, input, position + jump)

proc executeIntcode(integers: var seq[int], input: int): int =
  return executeIntcode(integers, input, 0)

proc main() =
  let inputFile = open("input.txt")
  let input = inputFile.readLine()
  inputFile.close()

  var integers = map(input.split(","), (x: string) => parseInt(x))
  echo executeIntcode(integers, 1)

main()
