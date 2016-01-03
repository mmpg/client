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
    @screen = new SystemScreen(@universe.systems[id])

  render: =>
    currentFrame = Date.now()
    delta = (currentFrame - @lastFrame) / 1000.0
    @lastFrame = currentFrame

    @gameStatus.update(delta)
    @screen.render(@renderer, delta)
    requestAnimationFrame(@render)
