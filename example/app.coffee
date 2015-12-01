angular.module 'mmpgViewer', ['ngMaterial', 'ngMessages', 'mmpgClient', 'mmpgLogin', 'mmpgDebug', 'mmpgGameTime']
  .config ($mdThemingProvider) ->
    $mdThemingProvider.theme('default')
      .dark()
      .backgroundPalette('grey', default: '900')
      .foregroundPalette['3'] = 'rgba(198,198,198,0.9)'

  .run ($timeout) ->
    apply = ->
      $timeout(apply, 500)

    apply()

class Message
  constructor: (@element, @speed=50) ->
    @hide()

  show: (msg) ->
    @reset()
    @text = msg
    @element.show()
    @hidden = false

  update: (delta) ->
    return if @hidden or @current_chars == @text.length

    @accum += delta
    num_chars = Math.min(@text.length, @speed * @accum / 1000)

    if @current_chars < num_chars
      @current_chars = num_chars
      @element.text(@text[0...@current_chars])

  hide: ->
    @element.hide()
    @hidden = true
    @reset()

  reset: ->
    @accum = 0
    @current_chars = 0

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

  client = angular.element(document.body).injector().get('Client')
  stream = angular.element(document.body).injector().get('EventStream')
  liveSubscriber = new MMPG.LiveSubscriber
  game = new MMPG.GameLoop(30)

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
