class Universe
  constructor: (data) ->
    @systems = data.systems
    @planets = []
    @relays = []
    @trips = []

    for system in data.systems
      @planets.push(planet) for planet in system.planets
      @relays.push(system.relay)

  onSync: (data) ->
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

  addFleet: (player, data) ->
    trip = new FleetTrip(
      @planets[data.origin],
      @planets[data.destination],
      data.ships,
      player
    )

    @trips.push(trip)
    trip

  addFleetThroughRelay: (player, data) ->
    [origin_relay, destination_relay] = data.relays

    relay_trip = new RelayTrip(
      @planets[data.origin],
      @relays[origin_relay],
      @relays[destination_relay],
      @planets[data.destination],
      data.ships,
      player
    )

    @trips.push(relay_trip)
    relay_trip

  update: (delta) ->
    i = @trips.length

    while i
      i -= 1

      trip = @trips[i]
      trip.update(delta)

      if trip.hasArrived()
        @trips.splice(i, 1)
