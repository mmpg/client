class System
  constructor: (data) ->
    @sun = new Sun(data.sun.radius)
    @relay = new Relay(data.relay)
    @planets = {}

    for planet in data.planets
      @planets[planet.id] = new Planet(
        planet.x,
        planet.y,
        planet.radius,
        if planet.owner >= 0 then planet.owner else -1,
        planet.ships || 0,
        planet.type,
        planet.rotation_direction,
        planet.rotation_speed
      )

    for planet in data.planets
      @planets[planet.id].setConnections(@planets[c] for c in planet.connections)
      @planets[planet.id].setRelay(@relay) if planet.relay != -1

  update: (data) ->
    for id, planet of @planets
      planet.update(data.planets[id*2], data.planets[id*2+1])

  render: (delta) ->
    planet.render(delta) for _, planet of @planets
    @relay.render(delta)

  addTo: (scene) ->
    @sun.addTo(scene)
    @relay.addTo(scene)
    planet.addTo(scene) for _, planet of @planets
