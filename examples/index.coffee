$ ->
  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera(75,
    window.innerWidth / window.innerHeight, 0.1, 100)

  renderer = new THREE.WebGLRenderer()
  renderer.setSize(window.innerWidth, window.innerHeight)

  $('body').append(renderer.domElement)

  geometry = new THREE.BoxGeometry(0.1, 0.1, 0.1)
  material = new THREE.MeshBasicMaterial({ color: 0x00ff00 })
  cube = new THREE.Mesh(geometry, material)

  scene.add(cube)

  camera.position.z = 5

  world = {
    synchronized: false
  }

  gameStatus = $('#gameStatus')
  gameStatus.text('Loading...')

  render = ->
    if world.synchronized
      cube.rotation.y += 0.01
      cube.rotation.x += 0.1
      renderer.render(scene, camera)

    requestAnimationFrame(render)


  handleSync = (data) ->
    cube.position.x = data.players[0].x
    cube.position.y = data.players[0].y
    world.synchronized = true
    gameStatus.text('')

  handleAction = (player, data) ->
    if data.type == 'move'
      switch data.direction
        when 'U' then cube.position.y += 0.1
        when 'D' then cube.position.y -= 0.1
        when 'R' then cube.position.x += 0.1
        when 'L' then cube.position.x -= 0.1

  client = new Client(window.location.hostname + ':8080')

  client.handleEvents(handleSync, handleAction)

  render()
