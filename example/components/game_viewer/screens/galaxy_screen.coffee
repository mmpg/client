class GalaxyScreen
  constructor: (data) ->
    @scene = new Scene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 300, 950)
    @loader = new THREE.TextureLoader()
    @camera.position.z = 450
    @galaxy = new Galaxy(data)

    Assets.objects.skydome.addTo(@scene)
    @galaxy.addTo(@scene)

  render: (renderer, delta) ->
    @scene.overlay.render(@camera, renderer.domElement)
    renderer.render(@scene.meshes, @camera)

  onSync: (data, universe) ->
    @galaxy.update(@scene, universe)

  onNewTrip: (trip) ->
    @galaxy.highlight(trip.origin.id)

  onNewRelayTrip: (relay_trip) ->
    
