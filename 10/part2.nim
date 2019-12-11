import algorithm, hashes, math, sets, sequtils, strutils

type Asteroid = ref object
  x: float
  y: float
  visibleAsteroids: HashSet[Asteroid]
  angleFromMonitoringStation: float

proc `==`(a: float, b: float): bool =
  return abs(a - b) < 0.000001

proc `==`(a: Asteroid, b: Asteroid): bool =
  return a.x == b.x and a.y == b.y

proc hash(asteroid: Asteroid): Hash =
  return hash(asteroid.x) !& hash(asteroid.y)

proc distance(a: Asteroid, b: Asteroid): float =
  return sqrt(((a.x - b.x) ^ 2) + ((a.y - b.y) ^ 2))

proc intersects(asteroid: Asteroid, a: Asteroid, b: Asteroid): bool =
  return distance(a, asteroid) + distance(asteroid, b) == distance(a, b)

proc hasDirectLineOfSight(asteroids: seq[Asteroid], a: Asteroid, b: Asteroid): bool =
  for asteroid in asteroids:
    if asteroid != a and asteroid != b and asteroid.intersects(a, b):
      return false
  return true

proc asteroidWithHighestVisibleAsteroids(asteroids: seq[Asteroid]): Asteroid =
  result = asteroids[0]
  for asteroid in asteroids[1..^1]:
    if asteroid.visibleAsteroids.len > result.visibleAsteroids.len:
      result = asteroid

proc main() =
  let inputFile = open("input.txt")
  let lines = inputFile.readAll().splitLines()
  inputFile.close()

  var asteroids: seq[Asteroid]

  for y, line in lines:
    for x, item in line:
      if item == '#':
        asteroids.add(Asteroid(x: x.toFloat, y: y.toFloat, visibleAsteroids: initHashSet[Asteroid]()))

  for a in asteroids:
    for b in asteroids:
      if a != b and asteroids.hasDirectLineOfSight(a, b):
        a.visibleAsteroids.incl(b)

  let monitoringStation = asteroids.asteroidWithHighestVisibleAsteroids()
  var asteroidsToVaporize = monitoringStation.visibleAsteroids.toSeq

  for asteroid in asteroidsToVaporize:
    var angle = arctan2(monitoringStation.y - asteroid.y, asteroid.x - monitoringStation.x).radToDeg - 90
    if angle <= 0:
      angle = 360 + angle
    asteroid.angleFromMonitoringStation = angle

  asteroidsToVaporize.sort(
    proc (a: Asteroid, b: Asteroid): int =
      return cmp(b.angleFromMonitoringStation, a.angleFromMonitoringStation)
  )

  echo int(asteroidsToVaporize[199].x * 100 + asteroidsToVaporize[199].y)

main()
