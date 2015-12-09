class Message
  constructor: (@element, @speed=50) ->
    @hide()

  show: (msg) ->
    @reset()
    @text = msg
    @element.show()
    @hidden = false

  update: (delta) ->
    return if @hidden or @current_chars == @text.length

    @accum += delta
    num_chars = Math.min(@text.length, @speed * @accum / 1000)

    if @current_chars < num_chars
      @current_chars = num_chars
      @element.text(@text[0...@current_chars])

  hide: ->
    @element.hide()
    @hidden = true
    @reset()

  reset: ->
    @accum = 0
    @current_chars = 0
