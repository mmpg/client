class Text
  constructor: (options) ->
    {x, y, content, klass = null} = options
    @object = document.createElement('div')
    @object.style.position = 'absolute'
    @object.className = klass if klass
    @position = new THREE.Vector3(x, y, 0)

    @setContent(content)

  render: (camera, canvas) ->
    pos = @project(@position, camera, canvas)

    @object.style.left = pos.x + 'px'
    @object.style.top = pos.y + 'px'

  project: (position, camera, canvas) ->
    pos = position.clone()
    projScreenMat = new THREE.Matrix4()
    projScreenMat.multiplyMatrices(camera.projectionMatrix, camera.matrixWorldInverse)
    pos.applyProjection(projScreenMat)

    return {
      x: (pos.x + 1) * canvas.width / 2.0 + canvas.offsetLeft,
      y: (-pos.y + 1) * canvas.height / 2.0 + canvas.offsetTop
    }

  setContent: (@content) ->
    @content = @content
    @object.innerHTML = @content
