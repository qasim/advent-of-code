import algorithm, sequtils, strutils, sugar

type Instruction = tuple[
  opcode: int,
  mode1: int,
  mode2: int,
  mode3: int
]

type IntcodeResult = tuple[
  code: int,
  value: int,
  position: int
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

proc executeIntcode(integers: var seq[int], inputs: var seq[int], position: int): IntcodeResult =
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

      return (code: 4, value: parameter1, position: position + 2)

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
      return (code: 99, value: 0, position: 0)

    else:
      echo "Something went wrong"
      quit(1)

  return integers.executeIntcode(inputs, newPosition)

proc amplify(integers: seq[int], phaseSettings: array[5, int]): int =
  var integersA = integers
  var integersB = integers
  var integersC = integers
  var integersD = integers
  var integersE = integers

  var lastResultA: IntcodeResult
  var lastResultB: IntcodeResult
  var lastResultC: IntcodeResult
  var lastResultD: IntcodeResult
  var lastResultE: IntcodeResult

  while true:
    var inputsA: seq[int]
    if lastResultA.code == 0:
      inputsA = @[phaseSettings[0], lastResultE.value]
    else:
      inputsA = @[lastResultE.value]
    lastResultA = integersA.executeIntcode(inputsA, lastResultA.position)
    if lastResultA.code == 99:
      break

    var inputsB: seq[int]
    if lastResultB.code == 0:
      inputsB = @[phaseSettings[1], lastResultA.value]
    else:
      inputsB = @[lastResultA.value]
    lastResultB = integersB.executeIntcode(inputsB, lastResultB.position)
    if lastResultB.code == 99:
      break

    var inputsC: seq[int]
    if lastResultC.code == 0:
      inputsC = @[phaseSettings[2], lastResultB.value]
    else:
      inputsC = @[lastResultB.value]
    lastResultC = integersC.executeIntcode(inputsC, lastResultC.position)
    if lastResultC.code == 99:
      break

    var inputsD: seq[int]
    if lastResultD.code == 0:
      inputsD = @[phaseSettings[3], lastResultC.value]
    else:
      inputsD = @[lastResultC.value]
    lastResultD = integersD.executeIntcode(inputsD, lastResultD.position)
    if lastResultD.code == 99:
      break

    var inputsE: seq[int]
    if lastResultE.code == 0:
      inputsE = @[phaseSettings[4], lastResultD.value]
    else:
      inputsE = @[lastResultD.value]
    let ampE = integersE.executeIntcode(inputsE, lastResultE.position)
    if ampE.code == 99:
      break
    else:
      lastResultE = ampE

  return lastResultE.value

proc highestSignal(integers: seq[int]): int =
  var phaseSettings = [5, 6, 7, 8, 9]
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
