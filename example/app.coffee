angular.module 'mmpgViewer', ['ngMaterial', 'mmpgLogin']

class Message
  constructor: (@element) ->

  show: (msg) ->
    @element.text msg
    @element.show()

  hide: ->
    @element.hide()

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

  gameStatus = new Message($('#gameStatus'))
  gameStatus.show('Loading...')

  client = new Client(window.location.hostname + ':8080')

  render = ->
    if client.synchronized
      cube.rotation.y += 0.01
      cube.rotation.x += 0.1
      renderer.render(scene, camera)

    requestAnimationFrame(render)

  handleDisconnect = ->
    gameStatus.show('Connection lost. Reconnecting...') if client.synchronized
    client.synchronized = false

  handleTimeout = ->
    gameStatus.show('Game paused') if client.synchronized
    client.synchronized = false

  handleSync = (data) ->
    cube.position.x = data.players[0].x
    cube.position.y = data.players[0].y
    gameStatus.hide()

  handleAction = (player, data) ->
    if data.type == 'move'
      switch data.direction
        when 'U' then cube.position.y += 0.1
        when 'D' then cube.position.y -= 0.1
        when 'R' then cube.position.x += 0.1
        when 'L' then cube.position.x -= 0.1

  client.handleEvents(
    sync: handleSync,
    disconnect: handleDisconnect,
    timeout: handleTimeout,
    action: handleAction
  )

  render()
