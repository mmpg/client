class Planet
  constructor: (@x, @y, @radius, @owner, @ships) ->
    @mesh = new THREE.Mesh(
      new THREE.SphereGeometry(@radius, 32, 32)
      new THREE.MeshPhongMaterial(color: 0x0000ff, shininess: 1)
    )

    @lines = []

    @mesh.position.x = @x
    @mesh.position.y = @y

    @ships_label = new Text(
      x: @x + @radius
      y: @y - @radius
      klass: 'ships-label'
      content: @ships
    )

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

  addTo: (scene) ->
    scene.meshes.add(@mesh)
    scene.meshes.add(line) for line in @lines
    scene.overlay.add(@ships_label)

  setShips: (@ships) ->
    @ships_label.setContent(@ships)
