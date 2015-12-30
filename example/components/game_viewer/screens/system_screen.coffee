class SystemScreen
  constructor: (@assets) ->
    @scene = new GameScene()
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 300, 950)
    @loader = new THREE.TextureLoader()
    @system = null
    @camera.position.z = 450
    @fleets = []

    Skydome.load @loader, (skydome) =>
      skydome.addTo(@scene)

  render: (renderer, delta) ->
    i = @fleets.length

    while i
      i -= 1

      fleet = @fleets[i]
      fleet.update(delta)

      if fleet.hasArrived()
        fleet.removeFrom(@scene)
        @fleets.splice(i, 1)

    @scene.overlay.render(@camera, renderer.domElement)
    renderer.render(@scene.meshes, @camera)

  onSync: (data) ->
    if @system
      @system.update(data.system)
    else
      @system = new System(data.system)
      @system.addTo(@scene)

  onAction: (player, data) ->
    switch data.type
      when 'send_fleet' then @addFleet(data.origin, data.destination, data.ships)

  addFleet: (origin_id, destination_id, ships) ->
    origin = @system.planets[origin_id]
    destination = @system.planets[destination_id]

    fleet = new Fleet(
      ships,
      new THREE.Vector2(origin.x, origin.y),
      new THREE.Vector2(destination.x, destination.y)
    )

    fleet.addTo(@scene)
    @fleets.push(fleet)
