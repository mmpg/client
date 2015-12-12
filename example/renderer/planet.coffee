class Planet
  constructor: (x, y, radius, connections) ->
    @mesh = new THREE.Mesh(
      new THREE.SphereGeometry(radius, 32, 32)
      new THREE.MeshPhongMaterial(color: 0x0000ff, shininess: 1)
    )

    @lines = []

    for connection in connections
      line = new THREE.Line3(
        new THREE.Vector3(x, y, 0),
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

    @mesh.position.x = x
    @mesh.position.y = y

  addTo: (scene) ->
    scene.add(@mesh)
    scene.add(line) for line in @lines
