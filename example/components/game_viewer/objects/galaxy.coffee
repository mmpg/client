class Galaxy
  constructor: (data) ->
    @systems = []
    @planet_systems = {}

    systemsPerArm = Math.min(data.systems.length, 50) * 1.0
    a = 40
    rotation = 0
    t = 2
    ti = 2 * Math.PI / systemsPerArm
    ri = 2 * Math.PI * systemsPerArm / data.systems.length

    for system in data.systems
      around = t + rotation

      x = a * t * Math.cos(around)
      y = a * t * Math.sin(around)

      @planet_systems[planet.id] = @systems.length for planet in system.planets
      @systems.push(new GSystem(@systems.length, x, y, system.relay, system.owner))

      t += ti

      if t >= 2 * Math.PI + 2
        t = 2
        rotation += ri

    system.setConnections(@systems) for system in @systems

  highlight: (planet) ->
    system = @planet_systems[planet]
    @systems[system].highlight()

  addTo: (scene) ->
    system.addTo(scene) for system in @systems

  update: (scene, universe) ->
    updated_systems = universe.systems

    for system in @systems
      if updated_systems[system.id].owner != system.owner
        scene.meshes.remove(system.mesh)
        system.changeOwner(updated_systems[system.id].owner)
        scene.meshes.add(system.mesh)

  systemForPlanet: (planet) ->
    @systems[@planet_systems[planet]]

class GSystem
  @SPHERE = new THREE.SphereGeometry(1, 32, 32)

  constructor: (@id, @x, @y, @relay, owner) ->
    @changeOwner(if owner >= 0 then owner else -1)
    @timer = null
    @lines = []

  setConnections: (systems) ->
    for id in @relay.connections
      connection = systems[id]

      line = new THREE.Line3(
        new THREE.Vector3(@x, @y, 0),
        new THREE.Vector3(connection.x, connection.y, 0)
      )
      material = new THREE.LineBasicMaterial(color: 0x888888);
      geometry = new THREE.Geometry();

      geometry.vertices.push(
        line.start,
        line.center(),
        line.end
      );

      geometry.computeLineDistances()

      @lines.push(new THREE.Line(geometry, material))

  changeOwner: (@owner) ->
    if @owner == -1
      @mesh = new THREE.Mesh(
        GSystem.SPHERE,
        new THREE.MeshBasicMaterial(color: 0xffffff)
      )
    else
      @mesh = new THREE.Sprite(
        new THREE.SpriteMaterial(map: Assets.textures.players[@owner])
      )

      @mesh.scale.x = 8
      @mesh.scale.y = 8

    @mesh.position.x = @x
    @mesh.position.y = @y

  highlight: ->
    clearTimeout(@timer) if @timer

    @mesh.material.color.setHex(0xff0000)

    @timer = setTimeout =>
      @mesh.material.color.setHex(0xffffff)
      @timer = null
    , 1000

  addTo: (scene) ->
    scene.meshes.add(@mesh)
    #scene.meshes.add(line) for line in @lines
