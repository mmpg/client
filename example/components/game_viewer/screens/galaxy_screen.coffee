class GalaxyScreen
  constructor: (data, assets) ->
    @scene = new Scene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 300, 950)
    @loader = new THREE.TextureLoader()
    @camera.position.z = 450
    @galaxy = new Galaxy(data)

    assets.skydome.addTo(@scene)
    @galaxy.addTo(@scene)

  render: (renderer, delta) ->
    @scene.overlay.render(@camera, renderer.domElement)
    renderer.render(@scene.meshes, @camera)

  onSync: (data) ->


  onAction: (player, data) ->
    switch data.type
      when 'send_fleet' then @galaxy.highlight(data.origin)
