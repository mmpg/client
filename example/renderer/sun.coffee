class Sun
  constructor: (radius, type) ->
    @mesh = new THREE.Mesh(
      new THREE.SphereGeometry(radius, 32, 32),
      new THREE.MeshBasicMaterial(color: 0xf47109)
    )
    @light = new THREE.PointLight(0xf47109, 40)

  addTo: (game) ->
    game.scene.add(@mesh)
    game.scene.add(@light)
