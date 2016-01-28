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
        viewer.onAction(player, data)

      element.append(viewer.renderer.domElement)

      $(window).resize ->
        containerWidth = window.innerWidth;
        containerHeight = window.innerHeight;
        viewer.setSize(containerWidth, containerHeight);

      viewer.render()

      start = ->
        viewer.status('Loading world...')

        Client.world()
          .success (universe) ->
            viewer.load universe, ->
              viewer.showGalaxy()
              EventStream.connect()
          .error ->
            setTimeout(start, 5000)

      start()
