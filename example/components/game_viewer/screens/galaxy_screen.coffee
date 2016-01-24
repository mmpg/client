class GalaxyScreen
  constructor: (data) ->
    @scene = new Scene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 300, 950)
    @loader = new THREE.TextureLoader()
    @camera.position.z = 450
    @galaxy = new Galaxy(data)
    @flash_trips = []

    Assets.objects.skydome.addTo(@scene)
    @galaxy.addTo(@scene)

    for trip in data.trips
      @onNewRelayTrip(trip) if trip.origin_trip

  render: (renderer, delta) ->
    i = @flash_trips.length

    while i
      i -= 1

      flash_trip = @flash_trips[i]

      if flash_trip.hasArrived()
        flash_trip.removeFrom(@scene)
        @flash_trips.splice(i, 1)
      else
        flash_trip.update(delta)

    @scene.overlay.render(@camera, renderer.domElement)
    renderer.render(@scene.meshes, @camera)

  onSync: (data, universe) ->
    @galaxy.update(@scene, universe)

  onNewTrip: (trip) ->
    @galaxy.highlight(trip.origin.id)

  onNewRelayTrip: (relay_trip) ->
    origin_system = @galaxy.systemForPlanet(relay_trip.origin_trip.origin.id)
    destination_system = @galaxy.systemForPlanet(relay_trip.destination_trip.destination.id)

    flash_trip = new FlashTrip(
      origin_system,
      destination_system,
      relay_trip
    )

    flash_trip.addTo(@scene)
    @flash_trips.push(flash_trip)


class FlashTrip
  @duration = 0.5

  constructor: (@origin, @destination, @relay_trip) ->
    @accum = 0.0
    @mesh = new THREE.Sprite(
      new THREE.SpriteMaterial(map: Assets.textures.players[@relay_trip.owner])
    )

    scale = 6.0
    @mesh.scale.x = scale
    @mesh.scale.y = scale

    @mesh.position.x = @origin.x
    @mesh.position.y = @origin.y
    @mesh.visible = false

    @origin_coords = new THREE.Vector2(@origin.x, @origin.y)
    @destination_coords = new THREE.Vector2(@destination.x, @destination.y)
    @direction = @destination_coords.clone().sub(@origin_coords)

  update: (delta) ->
    return unless @relay_trip.origin_trip.hasArrived()

    @accum += delta

    alpha = Math.min(@accum / FlashTrip.duration, 1.0)

    currentPosition = @origin_coords.clone().add(@direction.clone().multiplyScalar(alpha))
    @mesh.position.x = currentPosition.x
    @mesh.position.y = currentPosition.y
    @mesh.visible = true

  hasArrived: ->
    return @accum >= FlashTrip.duration

  addTo: (scene) ->
    scene.meshes.add(@mesh)

  removeFrom: (scene) ->
    scene.meshes.remove(@mesh)
