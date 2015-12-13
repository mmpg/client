class Text
  constructor: (@content, x, y) ->
    @object = document.createElement('div')
    @object.innerHTML = @content
    @object.style.position = 'absolute'
    @object.style.color = '#fff'

    @position = new THREE.Vector3(x, y, 0)

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
      x: (pos.x + 1) * canvas.width / 2 + canvas.offsetLeft,
      y: (-pos.y + 1) * canvas.height / 2 + canvas.offsetTop
    }
