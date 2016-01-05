class Galaxy
  constructor: (data, players) ->
    @systems = []
    @planet_systems = {}

    systemsPerArm = 50.0
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
      @systems.push(new GSystem(@systems.length, x, y, system.owner, players))

      t += ti

      if t >= 2 * Math.PI + 2
        t = 2
        rotation += ri

  highlight: (planet) ->
    system = @planet_systems[planet]
    @systems[system].highlight()

  addTo: (scene) ->
    scene.meshes.add(system.mesh) for system in @systems

  update: (scene, universe) ->
    updated_systems = universe.systems

    for system in @systems
      if updated_systems[system.id].owner != system.owner
        scene.meshes.remove(system.mesh)
        system.changeOwner(updated_systems[system.id].owner)
        scene.meshes.add(system.mesh)

class GSystem
  @SPHERE = new THREE.SphereGeometry(1, 32, 32)

  constructor: (@id, @x, @y, owner, @players) ->
    @changeOwner(if owner >= 0 then owner else -1)
    @timer = null

  changeOwner: (@owner) ->
    if @owner == -1
      @mesh = new THREE.Mesh(
        GSystem.SPHERE,
        new THREE.MeshBasicMaterial(color: 0xffffff)
      )
    else
      @mesh = new THREE.Sprite(
        new THREE.SpriteMaterial(map: @players[@owner])
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
