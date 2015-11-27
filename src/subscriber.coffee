class MMPG.Subscriber
  constructor: ->
    @synchronized = false
    @stopped = true
    @buffer = new MMPG.Buffer(60)
    @ticker = new MMPG.Ticker

  handleEvent: (event) ->
    [@time, msg, data...] = event.data.split(' ')

    if msg == 'SYNC'
      @synchronized = true
      @onSync(JSON.parse(data))

      clearTimeout(@timeout)
      @timeout = setTimeout(@triggerTimeout, 3000)

    else if @synchronized and msg == 'ACTION'
      @onAction(parseInt(data[0]), JSON.parse(data[1]))

  reset: ->
    @synchronized = false
    @stopped = true
    @buffer.clear()
    @ticker.clear()
    clearTimeout(@timeout)
    clearTimeout(@timer)

  start: ->
    return unless @stopped

    @stopped = false

    game_loop = =>
      return if @buffer.items.length == 0

      @ticker.tick()

      while @buffer.items.length > 0 and @ticker.accum >= @buffer.items[0][1]
        event = @buffer.items.shift()
        @handleEvent(event[0])
        @ticker.accum -= event[1]

      if @buffer.items.length > 0
        @timer = setTimeout(game_loop, @buffer.items[0][1] - @ticker.accum)
      else
        @reset()

    game_loop()

  triggerDisconnect: ->
    @onDisconnect()

  triggerTimeout: ->
    @onTimeout()

  onConnect: ->
  onDisconnect: ->
  onTimeout: ->
  onSync: ->
  onAction: ->
