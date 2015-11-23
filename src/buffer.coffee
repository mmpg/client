class MMPG.Buffer
  constructor: (@size, @callback) ->
    @clear()

  clear: ->
    @items = []
    @last_tick = 0
    @last_item = 0
    @accum = 0
    @stopped = true

  isEmpty: ->
    @items.length == 0

  isReady: ->
    @items.length >= @size

  length: ->
    @items.length

  add: (item, time) ->
    diff = if @last_item then time - @last_item else 0
    @last_item = time

    @items.push([item, diff])

    @play() if @stopped and @isReady()

  play: ->
    @stopped = false

    game_loop = =>
      return if @items.length == 0

      current_tick = Date.now()
      @last_tick = current_tick if @last_tick == 0
      @accum += current_tick - @last_tick
      @last_tick = current_tick

      while @items.length > 0 and @accum >= @items[0][1]
        event = @items.shift()
        @callback(event[0])
        @accum -= event[1]

      setTimeout(
        game_loop,
        if @items.length > 0 then @items[0][1] - @accum else 16.67
      )

    game_loop()
