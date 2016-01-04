class Galaxy
  constructor: (data) ->
    @planet_systems = {}
    @meshes = []
    @highlights = {}

    systemsPerArm = 50.0
    a = 40
    rotation = 0
    t = 2
    ti = 2 * Math.PI / systemsPerArm
    ri = 2 * Math.PI * systemsPerArm / data.systems.length

    for system in data.systems
      @planet_systems[planet.id] = @meshes.length for planet in system.planets

      mesh = new THREE.Mesh(
        new THREE.SphereGeometry(1, 32, 32)
        new THREE.MeshBasicMaterial(color: 0xffffff)
      )

      around = t + rotation

      mesh.position.x = a * t * Math.cos(around)
      mesh.position.y = a * t * Math.sin(around)

      t += ti

      if t >= 2 * Math.PI + 2
        t = 2
        rotation += ri

      @meshes.push(mesh)

  highlight: (planet) ->
    system = @planet_systems[planet]

    clearTimeout(@highlights[system]) if @highlights[system]

    mesh = @meshes[system]
    mesh.material.color.setHex(0xff0000)

    @highlights[system] = setTimeout =>
      mesh.material.color.setHex(0xffffff)
      @highlights[system] = null
    , 1000

  addTo: (scene) ->
    scene.meshes.add(mesh) for mesh in @meshes
