import strutils

type
  Coordinate = object
    x, y, z: int

type
  Moon = object
    position, velocity: Coordinate

proc
  applyGravity(moons: var seq[Moon], to: var Moon) =
    for moon in moons.mitems():
      if to == moon:
        continue

      if to.position.x > moon.position.x:
        to.velocity.x -= 1
      elif to.position.x < moon.position.x:
        to.velocity.x += 1

      if to.position.y > moon.position.y:
        to.velocity.y -= 1
      elif to.position.y < moon.position.y:
        to.velocity.y += 1

      if to.position.z > moon.position.z:
        to.velocity.z -= 1
      elif to.position.z < moon.position.z:
        to.velocity.z += 1

proc
  applyGravity(moons: var seq[Moon]) =
    for moon in moons.mitems():
      moons.applyGravity(moon)

proc
  applyVelocity(moon: var Moon) =
    moon.position.x += moon.velocity.x
    moon.position.y += moon.velocity.y
    moon.position.z += moon.velocity.z

proc
  applyVelocity(moons: var seq[Moon]) =
    for moon in moons.mitems():
      moon.applyVelocity()

proc
  applyMotion(moons: var seq[Moon]) =
    moons.applyGravity()
    moons.applyVelocity()

proc
  potentialEnergy(moon: Moon): int =
    return abs(moon.position.x) + abs(moon.position.y) + abs(moon.position.z)

proc
  kineticEnergy(moon: Moon): int =
    return abs(moon.velocity.x) + abs(moon.velocity.y) + abs(moon.velocity.z)

proc
  totalEnergy(moon: Moon): int =
    return moon.potentialEnergy() * moon.kineticEnergy()

proc totalEnergy(moons: seq[Moon]): int =
  for moon in moons:
    result += moon.totalEnergy()

proc
  main() =
    let inputFile = open("input.txt")
    defer: inputFile.close()

    var moons: seq[Moon]
    for rawMoonInfo in inputFile.lines():
      var moon = Moon()
      for axis in rawMoonInfo[1..^2].split(", "):
        let axis = axis.split("=")
        let name = axis[0]
        let value = parseInt(axis[1])
        case name:
          of "x": moon.position.x = value
          of "y": moon.position.y = value
          of "z": moon.position.z = value
      moons.add(moon)

    for i in 1 .. 1000:
      moons.applyMotion()

    echo moons.totalEnergy()

main()
