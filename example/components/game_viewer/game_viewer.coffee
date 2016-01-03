angular.module 'mmpgGameViewer', []
  .directive 'gameViewer', (Client, EventStream) ->
    restrict: 'E'
    link: (scope, element) ->
      viewer = new GameViewer()
      liveSubscriber = new MMPG.LiveSubscriber

      EventStream.notify(liveSubscriber)

      liveSubscriber.onConnect = ->
        viewer.onConnect()

      liveSubscriber.onDisconnect = ->
        viewer.onDisconnect() if liveSubscriber.buffer.isEmpty()

      liveSubscriber.onTimeout = ->
        viewer.onTimeout() if liveSubscriber.synchronized

      liveSubscriber.onSync = (data) ->
        viewer.onSync(data)

      liveSubscriber.onAction = (player, data) ->
        viewer.screen.onAction(player, data)

      element.append(viewer.renderer.domElement)

      Client.world()
        .success (universe) ->
          viewer.universe = universe
          viewer.showSystem(0)
          viewer.render()
          EventStream.connect()

class GameViewer
  constructor: ->
    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize(window.innerWidth, window.innerHeight)
    @lastFrame = Date.now()
    @gameStatus = new Message($('#gameStatus'))
    @keyboard = new THREEx.KeyboardState()
    @pressed = {}

  triggered: (key) ->
    if not @pressed[key]
      @pressed[key] = @keyboard.pressed(key)
      return @pressed[key]

    @pressed[key] = @keyboard.pressed(key)
    return false

  onConnect: ->
    @gameStatus.show('Loading...')

  onDisconnect: ->
    @gameStatus.show('Connection lost. Reconnecting...')

  onTimeout: ->
    @gameStatus.show('Game paused')

  onSync: (data) ->
    @gameStatus.hide()
    @screen.onSync(data)

  showSystem: (id) ->
    @current = if id < 0 then @universe.systems.length - 1 else id % @universe.systems.length
    @screen.scene.destroy() if @screen
    @screen = new SystemScreen(@universe.systems[@current])

  render: =>
    currentFrame = Date.now()
    delta = (currentFrame - @lastFrame) / 1000.0
    @lastFrame = currentFrame

    if @triggered("left")
      @showSystem(@current - 1)

    else if @triggered("right")
      @showSystem(@current + 1)

    @gameStatus.update(delta)
    @screen.render(@renderer, delta)
    requestAnimationFrame(@render)
