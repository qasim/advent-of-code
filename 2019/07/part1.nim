import algorithm, sequtils, strutils, sugar

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

proc executeIntcode(integers: var seq[int], inputs: var seq[int], position: int): int =
  let instruction = integers[position].instruction()
  var newPosition: int

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
      newPosition = position + 4

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
      newPosition = position + 4

    of 3:
      integers[integers[position + 1]] = inputs[0]

      if inputs.len > 1:
        inputs.delete(0)

      newPosition = position + 2

    of 4:
      var parameter1: int
      if instruction.mode1 == 0:
        parameter1 = integers[integers[position + 1]]
      else:
        parameter1 = integers[position + 1]

      return parameter1

    of 5:
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

      if parameter1 != 0:
        newPosition = parameter2
      else:
        newPosition = position + 3

    of 6:
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

      if parameter1 == 0:
        newPosition = parameter2
      else:
        newPosition = position + 3

    of 7:
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

      if parameter1 < parameter2:
        integers[integers[position + 3]] = 1
      else:
        integers[integers[position + 3]] = 0

      newPosition = position + 4

    of 8:
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

      if parameter1 == parameter2:
        integers[integers[position + 3]] = 1
      else:
        integers[integers[position + 3]] = 0

      newPosition = position + 4

    of 99:
      quit(0)

    else:
      echo "Something went wrong"
      quit(1)

  return integers.executeIntcode(inputs, newPosition)

proc executeIntcode(integers: seq[int], inputs: seq[int]): int =
  var integersCopy = integers
  var inputsCopy = inputs
  return integersCopy.executeIntcode(inputsCopy, 0)

proc amplify(integers: seq[int], phaseSettings: array[5, int]): int =
  let ampA = integers.executeIntcode(@[phaseSettings[0], 0])
  let ampB = integers.executeIntcode(@[phaseSettings[1], ampA])
  let ampC = integers.executeIntcode(@[phaseSettings[2], ampB])
  let ampD = integers.executeIntcode(@[phaseSettings[3], ampC])
  let ampE = integers.executeIntcode(@[phaseSettings[4], ampD])
  return ampE

proc highestSignal(integers: seq[int]): int =
  var phaseSettings = [0, 1, 2, 3, 4]
  var signals = @[integers.amplify(phaseSettings)]

  while phaseSettings.nextPermutation():
    signals.add(integers.amplify(phaseSettings))

  return signals.max()

proc main() =
  let inputFile = open("input.txt")
  let input = inputFile.readLine()
  inputFile.close()

  let integers = map(input.split(","), (x: string) => parseInt(x))
  echo integers.highestSignal()

main()
