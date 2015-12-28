class System
  constructor: (data) ->
    @sun = new Sun(data.sun.radius)
    @planets = {}

    for planet in data.planets
      @planets[planet.id] = new Planet(
        planet.x,
        planet.y,
        planet.radius,
        planet.owner,
        planet.ships
      )

    for planet in data.planets
      @planets[planet.id].setConnections(@planets[c] for c in planet.connections)

  update: (data) ->
    for planet in data.planets
      @planets[planet.id].setShips(planet.ships)

  addTo: (game) ->
    @sun.addTo(game)
    planet.addTo(game) for _, planet of @planets
