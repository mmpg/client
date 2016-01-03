class GameOverlay
  constructor: ->
    @objects = []

  add: (object) ->
    document.body.appendChild(object.object)
    @objects.push(object)

  render: (camera, canvas) ->
    object.render(camera, canvas) for object in @objects

  clear: ->
    document.body.removeChild(object.object) for object in @objects
