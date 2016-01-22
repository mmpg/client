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
    @universe.update(data)
    @gameStatus.hide()
    @screen.onSync(data, @universe)

  changeScreen: (screen) ->
    @screen.scene.destroy() if @screen
    @screen = screen

  showGalaxy: ->
    @changeScreen(new GalaxyScreen(@universe))
    @current = -1

  showSystem: (id) ->
    @current = if id < 0 then @universe.systems.length - 1 else id % @universe.systems.length
    @changeScreen(new SystemScreen(@universe.systems[@current]))

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
