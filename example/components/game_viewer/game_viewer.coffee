angular.module 'mmpgGameViewer', []
  .directive 'gameViewer', (Client, EventStream) ->
    restrict: 'E'
    link: (scope, element) ->
      viewer = new Viewer()
      liveSubscriber = new MMPG.LiveSubscriber

      EventStream.notify(liveSubscriber)

      liveSubscriber.onConnect = ->
        viewer.status('Connecting...')

      liveSubscriber.onDisconnect = ->
        viewer.status('Connection lost. Reconnecting...') if liveSubscriber.buffer.isEmpty()

      liveSubscriber.onTimeout = ->
        viewer.status('Game paused') if liveSubscriber.synchronized

      liveSubscriber.onSync = (data) ->
        viewer.onSync(data)

      liveSubscriber.onAction = (player, data) ->
        viewer.screen.onAction(player, data)

      element.append(viewer.renderer.domElement)
      viewer.render()

      viewer.load ->
        start = ->
          viewer.status('Loading world...')

          Client.world()
            .success (universe) ->
              viewer.universe = universe
              viewer.showGalaxy()
              EventStream.connect()
            .error ->
              start()

        start()
