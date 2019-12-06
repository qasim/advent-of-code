import sets, strutils, tables

proc path(orbitsTable: Table[string, seq[string]], start: string, finish: string): seq[string] =
  result.add(start)

  if start == finish:
    return

  if orbitsTable[start].contains(finish):
    result.add(finish)
    return

  for item in orbitsTable[start]:
    let path = path(orbitsTable, item, finish)
    if path.contains(finish):
      result.add(path)
      return

proc transfersRequired(orbitsTable: Table[string, seq[string]], item1: string, item2: string): int =
  let pathTo1 = orbitsTable.path("COM", item1)
  let pathTo2 = orbitsTable.path("COM", item2)

  var pathSet = initHashSet[string]()

  for item in pathTo1:
    if item notin pathTo2:
      pathSet.incl(item)

  for item in pathTo2:
    if item notin pathTo1:
      pathSet.incl(item)

  pathSet.excl(item1)
  pathSet.excl(item2)

  return pathSet.len

proc main() =
  let inputFile = open("input.txt")
  defer: inputFile.close()

  var orbitsTable = initTable[string, seq[string]]()

  for orbit in inputFile.lines:
    let items = orbit.split(")")

    if not orbitsTable.hasKey(items[0]):
      orbitsTable[items[0]] = newSeq[string]()

    if not orbitsTable.hasKey(items[1]):
      orbitsTable[items[1]] = newSeq[string]()

    orbitsTable[items[0]].add(items[1])

  echo orbitsTable.transfersRequired("YOU", "SAN")

main()
