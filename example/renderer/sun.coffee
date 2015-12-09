class Sun
  constructor: (radius, type) ->
    @mesh = new THREE.Mesh(
      new THREE.SphereGeometry(radius, 32, 32),
      new THREE.MeshBasicMaterial(color: 0xf47109)
    )
