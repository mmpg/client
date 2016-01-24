class SystemScreen
  constructor: (data, @current) ->
    @system = new System(data.systems[@current])
    @scene = new Scene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 300, 950)
    @loader = new THREE.TextureLoader()
    @camera.position.z = 450
    @fleets = []

    for trip in data.trips
      if trip.origin
        @onNewTrip(trip)
      else
        @onNewRelayTrip(trip)

    Assets.objects.skydome.addTo(@scene)
    @system.addTo(@scene)

  render: (renderer, delta) ->
    i = @fleets.length

    while i
      i -= 1
      fleet = @fleets[i]

      if fleet.trip.hasArrived()
        fleet.removeFrom(@scene)
        @fleets.splice(i, 1)
      else
        fleet.update()

    @scene.overlay.render(@camera, renderer.domElement)
    @system.render(delta)
    renderer.render(@scene.meshes, @camera)

  onSync: (data) ->
    @system.update(data)

  onNewTrip: (trip) ->
    origin = @system.planets[trip.origin.id]
    destination = @system.planets[trip.destination.id]

    return unless origin or destination

    fleet = new Fleet(trip)

    fleet.addTo(@scene)
    @fleets.push(fleet)

  onNewRelayTrip: (relay_trip) ->
    @onNewTrip(relay_trip.origin_trip)
    @onNewTrip(relay_trip.destination_trip)
