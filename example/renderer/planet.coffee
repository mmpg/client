class Planet
  constructor: (x, y, radius) ->
    @mesh = new THREE.Mesh(
      new THREE.SphereGeometry(radius, 32, 32)
      new THREE.MeshBasicMaterial(color: 0x0000ff)
    )

    @mesh.position.x = x
    @mesh.position.y = y
