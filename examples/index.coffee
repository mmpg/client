$ ->
  client = new Client('localhost:8080')

  client.handleEvents (event) ->
    console.log(event)

  scene = new THREE.Scene()
  camera = new THREE.PerspectiveCamera(75,
    window.innerWidth / window.innerHeight, 0.1, 100)

  renderer = new THREE.WebGLRenderer()
  renderer.setSize(window.innerWidth, window.innerHeight)

  $('body').append(renderer.domElement)

  geometry = new THREE.BoxGeometry(1, 1, 1)
  material = new THREE.MeshBasicMaterial({ color: 0x00ff00 })
  cube = new THREE.Mesh(geometry, material)

  scene.add(cube)

  camera.position.z = 5

  render = ->
    cube.rotation.y += 0.01
    cube.rotation.x += 0.1
    requestAnimationFrame(render)
    renderer.render(scene, camera)

  render()
