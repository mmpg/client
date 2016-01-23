class Relay
  constructor: (data) ->
    @x = data.x
    @y = data.y

    @mesh = new THREE.Mesh(
      new THREE.OctahedronGeometry(data.radius),
      new THREE.MeshPhongMaterial(color: 0x0000EE, shininess: 5)
    )

    @mesh.position.x = @x
    @mesh.position.y = @y

  render: (delta) ->
    @mesh.rotation.y = (@mesh.rotation.y + 2.0 * delta) % 360

  addTo: (scene) ->
    scene.meshes.add(@mesh)
