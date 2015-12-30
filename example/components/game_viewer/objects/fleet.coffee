class Fleet
  constructor: (@ships, @origin, destination) ->
    @mesh = new THREE.Mesh(
      new THREE.OctahedronGeometry(3.0),
      new THREE.MeshPhongMaterial(color: 0xff0000, shininess: 1)
    )

    @mesh.position.x = @origin.x
    @mesh.position.y = @origin.y

    @timeLeft = @origin.distanceTo(destination) / 40.0
    @direction = destination.sub(@origin)
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
