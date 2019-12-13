import strutils

type Size = tuple[width: int, height: int]

proc layers(input: string, size: Size): seq[string] =
  for i in countup(0, input.len - 1, size.width * size.height):
    result.add(input[i .. i + (size.width * size.height - 1)])

proc layerWithFewest0Digits(layers: seq[string]): string =
  result = layers[0]
  for layer in layers[1..^1]:
    if layer.count('0') < result.count('0'):
      result = layer

proc main() =
  let inputFile = open("input.txt")
  let input = inputFile.readLine()
  inputFile.close()

  let layers = layers(input, (width: 25, height: 6))
  let layerWithFewest0Digits = layerWithFewest0Digits(layers)
  echo layerWithFewest0Digits.count('1') * layerWithFewest0Digits.count('2')

main()
