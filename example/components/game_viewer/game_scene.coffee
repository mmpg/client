class GameScene
  constructor: ->
    @meshes = new THREE.Scene()
    @overlay = new GameOverlay()

  destroy: ->
    @overlay.clear()
