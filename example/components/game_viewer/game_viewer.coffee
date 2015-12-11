angular.module 'mmpgGameViewer', []
  .directive 'gameViewer', (EventStream) ->
    restrict: 'E'
    link: (scope, element) ->
      scene = new THREE.Scene()

      camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 250, 900)
      camera.position.z = 400

      renderer = new THREE.WebGLRenderer()
      renderer.setSize(window.innerWidth, window.innerHeight)
      element.append(renderer.domElement)

      loader = new THREE.TextureLoader()

      Skydome.load loader, (skydome) ->
        skydome.addTo(scene)

      geometry = new THREE.BoxGeometry(0.1, 0.1, 0.1)
      material = new THREE.MeshBasicMaterial(color: 0x00ff00)
      cube = new THREE.Mesh(geometry, material)

      scene.add(cube)

      gameStatus = new Message($('#gameStatus'))

      stream = EventStream
      liveSubscriber = new MMPG.LiveSubscriber
      game = new MMPG.GameLoop(30)
      first = true

      game.entities.push(gameStatus)

      stream.notify(liveSubscriber)

      liveSubscriber.onConnect = ->
        gameStatus.show('Loading...')

      liveSubscriber.onDisconnect = ->
        gameStatus.show('Connection lost. Reconnecting...') if liveSubscriber.buffer.isEmpty()

      liveSubscriber.onTimeout = ->
        gameStatus.show('Game paused') if liveSubscriber.synchronized

      liveSubscriber.onSync = (data) ->
        cube.position.x = data.players[0].x
        cube.position.y = data.players[0].y

        if first
          first = false

          sun = new Sun(data.system.sun.radius)
          sun.addTo(scene)

          for planet in data.system.planets
            p = new Planet(planet.x, planet.y, planet.radius)
            p.addTo(scene)

        gameStatus.hide()

      liveSubscriber.onAction = (player, data) ->
        if data.type == 'move'
          switch data.direction
            when 'U' then cube.position.y += 0.1
            when 'D' then cube.position.y -= 0.1
            when 'R' then cube.position.x += 0.1
            when 'L' then cube.position.x -= 0.1

      render = ->
        if stream.subscriber.synchronized
          cube.rotation.y += 0.01
          cube.rotation.x += 0.1

        renderer.render(scene, camera)
        requestAnimationFrame(render)

      render()
      stream.connect()
      game.start()
