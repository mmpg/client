class Fleet
  constructor: (@ships, @owner, @origin, destination) ->
    colors = [0xff0000, 0x00ff00]

    @mesh = new THREE.Mesh(
      new THREE.OctahedronGeometry(Math.max(3.0, Math.min(@ships / 20.0, 10.0))),
      new THREE.MeshPhongMaterial(color: colors[@owner], shininess: 1)
    )

    @timeLeft = @origin.distanceTo(destination) / 40.0
    @direction = destination.sub(@origin)

    @origin.add(new THREE.Vector2(@direction.y, -@direction.x).normalize().multiplyScalar(5.0))

    @mesh.position.x = @origin.x
    @mesh.position.y = @origin.y

    @accum = 0.0

  addTo: (scene) ->
    scene.meshes.add(@mesh)

  removeFrom: (scene) ->
    scene.meshes.remove(@mesh)

  update: (delta) ->
    @accum += delta

    alpha = @accum / @timeLeft

    currentPosition = @origin.clone().add(@direction.clone().multiplyScalar(alpha))
    @mesh.position.x = currentPosition.x
    @mesh.position.y = currentPosition.y

  hasArrived: ->
    return @accum >= @timeLeft
