class MMPG.Buffer
  constructor: (@size, @callback) ->
    @ticker = new MMPG.Ticker
    @clear()

  clear: ->
    @items = []
    @last_item = 0
    @stopped = true
    @ticker.clear()

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

      @ticker.tick()

      while @items.length > 0 and @ticker.accum >= @items[0][1]
        event = @items.shift()
        @callback(event[0])
        @ticker.accum -= event[1]

      if @items.length > 0
        setTimeout(game_loop, @items[0][1] - @ticker.accum)
      else
        @clear()

    game_loop()
