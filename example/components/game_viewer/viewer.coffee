class Viewer
  constructor: ->
    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize(window.innerWidth, window.innerHeight)
    @lastFrame = Date.now()
    @gameStatus = new Message($('#gameStatus'))
    @keyboard = new THREEx.KeyboardState()
    @pressed = {}
    @current = -1
    @screen = new LoadingScreen()

  load: (data, callback) ->
    @universe = new Universe(data)
    @gameStatus.show('Loading assets...')

    Assets.load [0...150], callback

  triggered: (key) ->
    if not @pressed[key]
      @pressed[key] = @keyboard.pressed(key)
      return @pressed[key]

    @pressed[key] = @keyboard.pressed(key)
    return false

  status: (msg) ->
    if msg then @gameStatus.show(msg) else @gameStatus.hide()

  onSync: (data) ->
    @universe.onSync(data)
    @gameStatus.hide()
    @screen.onSync(data, @universe)

  onAction: (player, data) ->
    switch data.type
      when 'send_fleet'
        trip = @universe.addFleet(player, data)
        @screen.onNewTrip(trip)

      when 'send_fleet_through_relay'
        relay_trip = @universe.addFleetThroughRelay(player, data)
        @screen.onNewRelayTrip(relay_trip)

  changeScreen: (screen) ->
    @screen.scene.destroy() if @screen
    @screen = screen

  showGalaxy: ->
    @changeScreen(new GalaxyScreen(@universe))
    @current = -1

  showSystem: (id) ->
    @current = if id < 0 then @universe.systems.length - 1 else id % @universe.systems.length
    @changeScreen(new SystemScreen(@universe, @current))

  onClick: (event) ->
    return unless @screen and @screen.camera and @screen.scene

    raycaster = new THREE.Raycaster()
    mouse = new THREE.Vector2()

    mouse.x = (event.clientX / @renderer.domElement.clientWidth) * 2 - 1
    mouse.y = - (event.clientY / @renderer.domElement.clientHeight) * 2 + 1

    raycaster.setFromCamera(mouse, @screen.camera)

    intersects = raycaster.intersectObjects(@screen.scene.meshes.children)

    if intersects.length > 0 and intersects[0].object.callback
      intersects[0].object.callback(this)

  setSize: (width, height) ->
    @renderer.setSize(width, height)

    if @screen and @screen.camera
      @screen.camera.aspect = width / height;
      @screen.camera.updateProjectionMatrix();

  render: =>
    currentFrame = Date.now()
    delta = (currentFrame - @lastFrame) / 1000.0
    @lastFrame = currentFrame

    if @triggered("left")
      @showSystem(@current - 1)

    else if @triggered("right")
      @showSystem(@current + 1)

    else if @triggered("g")
      @showGalaxy()

    @universe.update(delta) if @universe
    @gameStatus.update(delta)
    @screen.render(@renderer, delta)
    requestAnimationFrame(@render)
