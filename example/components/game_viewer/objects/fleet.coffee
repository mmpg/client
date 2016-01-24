class Fleet
  constructor: (@trip) ->
    colors = [0xff0000, 0x00ff00]

    @mesh = new THREE.Sprite(
      new THREE.SpriteMaterial(map: Assets.textures.players[@trip.owner])
    )

    scale = Math.max(3.0, Math.min(@trip.ships / 20.0, 10.0)) * 2.0
    @mesh.scale.x = scale
    @mesh.scale.y = scale

    @direction = @trip.coords.destination.clone().sub(@trip.coords.origin)
    @origin = @trip.coords.origin.clone().add(new THREE.Vector2(@direction.y, -@direction.x).normalize().multiplyScalar(5.0))

    @mesh.position.x = @origin.x
    @mesh.position.y = @origin.y

    @accum = 0.0

  addTo: (scene) ->
    scene.meshes.add(@mesh)

  removeFrom: (scene) ->
    scene.meshes.remove(@mesh)

  update: ->
    alpha = @trip.accum / @trip.time

    currentPosition = @origin.clone().add(@direction.clone().multiplyScalar(alpha))
    @mesh.position.x = currentPosition.x
    @mesh.position.y = currentPosition.y
    @mesh.visible = @trip.started

class FleetTrip
  constructor: (@origin, @destination, @ships, @owner) ->
    @coords = {
      origin: new THREE.Vector2(@origin.x, @origin.y),
      destination: new THREE.Vector2(@destination.x, @destination.y)
    }

    @time = @coords.origin.distanceTo(@coords.destination) / 40.0
    @accum = 0.0
    @started = false

  update: (delta) ->
    @started = true
    @accum += delta

  hasArrived: ->
    return @accum >= @time

class RelayTrip
  constructor: (origin, origin_relay, destination_relay, destination, @ships, @owner) ->
    @origin_trip = new FleetTrip(
      origin,
      origin_relay,
      @ships,
      @owner
    )

    @destination_trip = new FleetTrip(
      destination_relay,
      destination,
      @ships,
      @owner
    )

    @time = @origin_trip.time + @destination_trip.time

  update: (delta) ->
    if @origin_trip.hasArrived()
      @destination_trip.update(delta)
    else
      @origin_trip.update(delta)

  hasArrived: ->
    return @origin_trip.hasArrived() and @destination_trip.hasArrived()
