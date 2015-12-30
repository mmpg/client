class SystemScreen
  constructor: (@assets) ->
    @scene = new GameScene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 300, 950)
    @loader = new THREE.TextureLoader()
    @system = null
    @camera.position.z = 450

    Skydome.load @loader, (skydome) =>
      skydome.addTo(@scene)

  onSync: (data) ->
    if @system
      @system.update(data.system)
    else
      @system = new System(data.system)
      @system.addTo(@scene)

  render: (renderer, delta) ->
    @scene.overlay.render(@camera, renderer.domElement)
    renderer.render(@scene.meshes, @camera)
