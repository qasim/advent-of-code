import math, strutils

type
  Coordinate = object
    x, y, z: BiggestInt

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
  main() =
    let inputFile = open("input.txt")
    defer: inputFile.close()

    var moons: seq[Moon]
    for rawMoonInfo in inputFile.lines():
      var moon = Moon()
      for axis in rawMoonInfo[1..^2].split(", "):
        let axis = axis.split("=")
        let name = axis[0]
        let value = parseBiggestInt(axis[1])
        case name:
          of "x": moon.position.x = value
          of "y": moon.position.y = value
          of "z": moon.position.z = value
      moons.add(moon)

    var xInitialState, yInitialState, zInitialState: seq[BiggestInt]
    for moon in moons:
      xInitialState.add(moon.position.x)
      xInitialState.add(moon.velocity.x)

      yInitialState.add(moon.position.y)
      yInitialState.add(moon.velocity.y)

      zInitialState.add(moon.position.z)
      zInitialState.add(moon.velocity.z)

    var xSteps, ySteps, zSteps: BiggestInt = 1
    var xIsDone, yIsDone, zIsDone: bool

    while false in [xIsDone, yIsDone, zIsDone]:
      moons.applyMotion()

      var xState, yState, zState: seq[BiggestInt]
      for moon in moons:
        xState.add(moon.position.x)
        xState.add(moon.velocity.x)

        yState.add(moon.position.y)
        yState.add(moon.velocity.y)

        zState.add(moon.position.z)
        zState.add(moon.velocity.z)

      if not xIsDone:
        if xState == xInitialState:
          xIsDone = true
        else:
          xSteps += 1

      if not yIsDone:
        if yState == yInitialState:
          yIsDone = true
        else:
          ySteps += 1

      if not zIsDone:
        if zState == zInitialState:
          zIsDone = true
        else:
          zSteps += 1

    echo lcm(xSteps, lcm(ySteps, zSteps))

main()
