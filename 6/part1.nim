import strutils, tables

proc totalOrbits(orbitsTable: Table[string, seq[string]], item: string, depth: int): int =
  if orbitsTable.hasKey(item):
    for item in orbitsTable[item]:
      result += depth + totalOrbits(orbitsTable, item, depth + 1)

proc totalOrbits(orbitsTable: Table[string, seq[string]]): int =
  return totalOrbits(orbitsTable, "COM", 1)

proc main() =
  let inputFile = open("input.txt")
  defer: inputFile.close()

  var orbitsTable = initTable[string, seq[string]]()

  for orbit in inputFile.lines:
    let items = orbit.split(")")

    if not orbitsTable.hasKey(items[0]):
      orbitsTable[items[0]] = newSeq[string]()

    orbitsTable[items[0]].add(items[1])

  echo totalOrbits(orbitsTable)

main()
