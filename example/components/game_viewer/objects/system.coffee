class System
  constructor: (data) ->
    @sun = new Sun(data.sun.radius)
    @planets = {}

    for planet in data.planets
      @planets[planet.id] = new Planet(
        planet.x,
        planet.y,
        planet.radius,
        if planet.owner >= 0 then planet.owner else -1,
        planet.ships || 0
      )

    for planet in data.planets
      @planets[planet.id].setConnections(@planets[c] for c in planet.connections)

  update: (data) ->
    for id, planet of @planets
      planet.update(data.planets[id*2], data.planets[id*2+1])

  addTo: (scene) ->
    @sun.addTo(scene)
    planet.addTo(scene) for _, planet of @planets
