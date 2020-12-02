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

proc main() =
  let inputFile = open("input.txt")
  let input = inputFile.readLine()
  inputFile.close()

  var integers = map(input.split(","), proc(x: string): int = parseInt(x))
  let result = executeIntcode(integers)
  echo result

main()
