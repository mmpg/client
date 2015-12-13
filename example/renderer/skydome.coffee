class Skydome
  @load: (loader, callback) ->
    loader.load "space2.png", (texture) ->
      instance = new Skydome(texture)
      callback(instance)

  constructor: (texture) ->
    geometry = new THREE.SphereGeometry(500, 20, 20)
    material = new THREE.MeshBasicMaterial(
      map: texture
      side: THREE.BackSide
    )
    material.map.wrapS = THREE.RepeatWrapping
    material.map.wrapT = THREE.RepeatWrapping
    material.map.repeat.set(5, 3)

    @mesh = new THREE.Mesh(geometry, material)

  addTo: (game) ->
    game.scene.add(@mesh)
