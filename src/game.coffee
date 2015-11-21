class Game
  constructor: (@buffer_size) ->
    @reset()

  reset: ->
    @buffer = []
    @last_tick = 0
    @accum = 0
    @stopped = true

  is_ready: ->
    @buffer.length >= @buffer_size

  play: (callback) ->
    @stopped = false

    game_loop = =>
      return if @buffer.length == 0

      current_tick = Date.now()
      @last_tick = current_tick if @last_tick == 0
      @accum += current_tick - @last_tick
      @last_tick = current_tick

      while @buffer.length > 0 and @accum >= @buffer[0][1]
        event = @buffer.shift()
        callback(event[0])
        @accum -= event[1]

      setTimeout(
        game_loop,
        if @buffer.length > 0 then @buffer[0][1] - @accum else 16.67
      )

    game_loop()
