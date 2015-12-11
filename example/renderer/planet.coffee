class Planet
  constructor: (x, y, radius) ->
    @mesh = new THREE.Mesh(
      new THREE.SphereGeometry(radius, 32, 32)
      new THREE.MeshPhongMaterial(color: 0x0000ff, shininess: 1)
    )

    @mesh.position.x = x
    @mesh.position.y = y

  addTo: (scene) ->
    scene.add(@mesh)
