angular.module 'mmpgGameViewer', []
  .directive 'gameViewer', (EventStream) ->
    restrict: 'E'
    link: (scope, element) ->
      # TODO: Move this code into a Viewer class and refactor it
      viewer = new GameViewer(new SystemScreen())
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

      viewer.render()
      EventStream.connect()

class GameViewer
  constructor: (@screen) ->
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

  render: =>
    currentFrame = Date.now()
    delta = (currentFrame - @lastFrame) / 1000.0
    @lastFrame = currentFrame

    @gameStatus.update(delta)
    @screen.render(@renderer, delta)
    requestAnimationFrame(@render)
