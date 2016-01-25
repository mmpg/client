class Planet
  constructor: (@x, @y, @radius, @owner, @ships, @type, @rotation_direction, @rotation_speed) ->
    @mesh = new THREE.Mesh(
      new THREE.SphereGeometry(@radius, 32, 32)
      new THREE.MeshPhongMaterial(color: 0x666666, shininess: 0, map: Assets.textures["planet#{@type}"])
    )

    @mesh.material.specular = new THREE.Color(0x000000)

    @lines = []

    @mesh.position.x = @x
    @mesh.position.y = @y

    @label = new Text(
      x: @x + @radius
      y: @y - @radius
      klass: 'ships-label'
      content: @ships
    )

    @update(@owner, @ships)

  setConnections: (connections) ->
    for connection in connections
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

  setRelay: (relay) ->
    line = new THREE.Line3(
      new THREE.Vector3(@x, @y, 0),
      new THREE.Vector3(relay.x, relay.y, 0)
    )
    material = new THREE.LineBasicMaterial(color: 0x8888ff);
    geometry = new THREE.Geometry();

    geometry.vertices.push(
      line.start,
      line.center(),
      line.end
    );

    geometry.computeLineDistances()

    @lines.push(new THREE.Line(geometry, material))

  addTo: (scene) ->
    scene.meshes.add(@mesh)
    scene.meshes.add(line) for line in @lines
    scene.overlay.add(@label)

  update: (@owner, @ships) ->
    player = if @owner >= 0 then "<br /><small>Player #{@owner+1}</small>" else ""
    @label.setContent("#{@ships}#{player}")

  render: (delta) ->
    @mesh.rotation.y += delta * @rotation_speed * @rotation_direction / 10.0
