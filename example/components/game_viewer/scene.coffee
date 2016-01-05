class Scene
  constructor: ->
    @meshes = new THREE.Scene()
    @overlay = new Overlay()

  destroy: ->
    @overlay.clear()
