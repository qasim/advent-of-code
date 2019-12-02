import sequtils, strutils

proc executeIntcode(integers: var seq[int], position: int): int =
  let opcode = integers[position]

  case opcode:
    of 1:
      let firstValue = integers[integers[position + 1]]
      let secondValue = integers[integers[position + 2]]
      integers[integers[position + 3]] = firstValue + secondValue

    of 2:
      let firstValue = integers[integers[position + 1]]
      let secondValue = integers[integers[position + 2]]
      integers[integers[position + 3]] = firstValue * secondValue

    of 99:
      return integers[0]

    else:
      echo "Something went wrong"
      quit(1)

  return executeIntcode(integers, position + 4)

proc executeIntcode(integers: var seq[int]): int =
  return executeIntcode(integers, 0)

proc inputPair(integers: seq[int], desiredOutput: int): tuple[noun: int, verb: int] =
  type NounRange = range[0 .. 99]
  var noun = NounRange.low

  while noun < NounRange.high:
    type VerbRange = range[0 .. 99]
    var verb = VerbRange.low

    while verb < VerbRange.high:
      var integersCopy = integers
      integersCopy[1] = noun
      integersCopy[2] = verb
      let output = executeIntcode(integersCopy)
      if output == desiredOutput:
        return (noun, verb)
      inc verb
    inc noun

  echo "Something went wrong"
  quit(1)

proc main() =
  let inputFile = open("input.txt")
  let input = inputFile.readLine()
  inputFile.close()

  let integers = map(input.split(","), proc(x: string): int = parseInt(x))
  let inputPair = inputPair(integers, 19690720)
  echo 100 * inputPair.noun + inputPair.verb

main()
