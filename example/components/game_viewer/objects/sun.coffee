class Sun
  @VERTEX_SHADER = """
  varying vec3 vNormal;
  void main()
  {
    vNormal = normalize(normalMatrix * normal);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  }
  """

  @FRAGMENT_SHADER = """
  varying vec3 vNormal;
  uniform vec3 color;

  void main()
  {
    float intensity = pow(0.4 - dot(vNormal, vec3(0.0, 0.0, 1.0)), 4.0);
    gl_FragColor = vec4(color, 1.0) * intensity;
  }
  """

  constructor: (radius, type) ->
    @mesh = new THREE.Mesh(
      new THREE.SphereGeometry(radius, 32, 32),
      new THREE.MeshPhongMaterial(color: 0xf47109, emissive: 0xf47109)
    )

    @light = new THREE.PointLight(0xffffff, 5)
    @ambient = new THREE.AmbientLight(0xA0A0A0);

    glowMaterial = new THREE.ShaderMaterial(
      uniforms: { color: { type: 'c', value: new THREE.Color(0xf47109) } }
      vertexShader: Sun.VERTEX_SHADER
      fragmentShader: Sun.FRAGMENT_SHADER
      side: THREE.BackSide
      blending: THREE.AdditiveBlending
      transparent: true
    )

    @glow = new THREE.Mesh(
      new THREE.SphereGeometry(radius + radius / 3, 32, 32),
      glowMaterial
    )

  addTo: (scene) ->
    scene.meshes.add(@mesh)
    scene.meshes.add(@glow)
    scene.meshes.add(@light)
    scene.meshes.add(@ambient)
