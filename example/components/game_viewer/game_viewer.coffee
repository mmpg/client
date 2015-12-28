angular.module 'mmpgGameViewer', []
  .directive 'gameViewer', (EventStream) ->
    restrict: 'E'
    link: (scope, element) ->
      # TODO: Move this code into a Viewer class and refactor it
      scene = new THREE.Scene()

      camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 300, 950)
      camera.position.z = 450

      renderer = new THREE.WebGLRenderer()
      renderer.setSize(window.innerWidth, window.innerHeight)
      element.append(renderer.domElement)

      loader = new THREE.TextureLoader()

      game = {
        scene: scene,
        overlay: new Overlay()
      }

      Skydome.load loader, (skydome) ->
        skydome.addTo(game)

      geometry = new THREE.BoxGeometry(0.1, 0.1, 0.1)
      material = new THREE.MeshBasicMaterial(color: 0x00ff00)
      cube = new THREE.Mesh(geometry, material)

      scene.add(cube)

      gameStatus = new Message($('#gameStatus'))

      stream = EventStream
      liveSubscriber = new MMPG.LiveSubscriber
      first = true
      system = null

      stream.notify(liveSubscriber)

      liveSubscriber.onConnect = ->
        gameStatus.show('Loading...')

      liveSubscriber.onDisconnect = ->
        gameStatus.show('Connection lost. Reconnecting...') if liveSubscriber.buffer.isEmpty()

      liveSubscriber.onTimeout = ->
        gameStatus.show('Game paused') if liveSubscriber.synchronized

      liveSubscriber.onSync = (data) ->
        if first
          system = new System(data.system)
          system.addTo(game)
          first = false
        else
          system.update(data.system)

        gameStatus.hide()

      liveSubscriber.onAction = (player, data) ->


      render = ->
        game.overlay.render(camera, renderer.domElement)

        renderer.render(scene, camera)
        requestAnimationFrame(render)

      render()
      stream.connect()

      gameLoop = new MMPG.GameLoop(30)
      gameLoop.entities.push(gameStatus)
      gameLoop.start()
