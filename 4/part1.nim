import algorithm, nre, sequtils, strutils, sugar

proc possiblePasswords(lowerBound: int, upperBound: int): seq[int] =
  let sameAdjacentDigits = re"(\d)\1"

  for password in lowerBound .. upperBound:
    let passwordString = intToStr(password)

    if passwordString.find(sameAdjacentDigits).isNone:
      continue

    if not passwordString.isSorted():
      continue

    result.add(password)

proc main() =
  let inputFile = open("input.txt")
  let input = inputFile.readLine()
  inputFile.close()

  let bounds = map(input.split("-"), (x: string) => parseInt(x))
  echo possiblePasswords(bounds[0], bounds[1]).len

main()
