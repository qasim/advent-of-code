import strutils

type Size = tuple[width: int, height: int]

proc layers(input: string, size: Size): seq[string] =
  for i in countup(0, input.len - 1, size.width * size.height):
    result.add(input[i .. i + (size.width * size.height - 1)])

proc decodeImage(layers: seq[string]): string =
  result = layers[0]
  for layer in layers[1..^1]:
    for i, pixel in layer:
      if result[i] == '2':
        result[i] = pixel

proc printableImage(image: string, size: Size): string =
  var lines: seq[string]
  for i in countup(0, image.len - 1, size.width):
    lines.add(image[i .. i + (size.width - 1)])
  return lines.join("\n").replace("0", "⬛️").replace("1", "⬜️")

proc main() =
  let inputFile = open("input.txt")
  let input = inputFile.readLine()
  inputFile.close()

  let size = (width: 25, height: 6)
  let layers = layers(input, size)
  let image = decodeImage(layers)
  echo printableImage(image, size)

main()
