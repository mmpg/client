class GalaxyScreen
  constructor: (data) ->
    @scene = new GameScene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 300, 950)
    @loader = new THREE.TextureLoader()
    @camera.position.z = 450
    @galaxy = new Galaxy(data)

    Skydome.load @loader, (skydome) =>
      skydome.addTo(@scene)
      @galaxy.addTo(@scene)

  render: (renderer, delta) ->
    @scene.overlay.render(@camera, renderer.domElement)
    renderer.render(@scene.meshes, @camera)

  onSync: (data) ->


  onAction: (player, data) ->
    switch data.type
      when 'send_fleet' then @galaxy.highlight(data.origin)
