class Viewer
  constructor: ->
    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize(window.innerWidth, window.innerHeight)
    @lastFrame = Date.now()
    @gameStatus = new Message($('#gameStatus'))
    @keyboard = new THREEx.KeyboardState()
    @pressed = {}
    @current = -1
    @assets = new Assets()
    @screen = new LoadingScreen()

  load: (callback) ->
    @gameStatus.show('Loading assets...')
    @assets.load(callback)

  triggered: (key) ->
    if not @pressed[key]
      @pressed[key] = @keyboard.pressed(key)
      return @pressed[key]

    @pressed[key] = @keyboard.pressed(key)
    return false

  status: (msg) ->
    if msg then @gameStatus.show(msg) else @gameStatus.hide()

  onSync: (data) ->
    if @universe
      for system in @universe.systems
        for planet in system.planets
          planet.owner = data.planets[planet.id*2]
          planet.ships = data.planets[planet.id*2+1]

    @gameStatus.hide()
    @screen.onSync(data)

  changeScreen: (screen) ->
    @screen.scene.destroy() if @screen
    @screen = screen

  showGalaxy: ->
    @changeScreen(new GalaxyScreen(@universe, @assets))
    @current = -1

  showSystem: (id) ->
    @current = if id < 0 then @universe.systems.length - 1 else id % @universe.systems.length
    @changeScreen(new SystemScreen(@universe.systems[@current], @assets))

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

    @gameStatus.update(delta)
    @screen.render(@renderer, delta)
    requestAnimationFrame(@render)
