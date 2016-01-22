class Universe
  constructor: (data) ->
    @systems = data.systems

  update: (data) ->
    for system in @systems
      new_owner = -1
      players = {}

      for planet in system.planets
        planet.owner = data.planets[planet.id*2]
        planet.ships = data.planets[planet.id*2+1]

        if planet.owner >= 0
          players[planet.owner] ||= 0
          players[planet.owner] += 1

          if new_owner < 0 or players[planet.owner] > players[new_owner]
            new_owner = planet.owner

        system.owner = new_owner
