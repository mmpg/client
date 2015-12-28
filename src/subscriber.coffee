class MMPG.Subscriber
  constructor: ->
    @synchronized = false
    @stopped = true
    @buffer = new MMPG.Buffer(2000)
    @ticker = new MMPG.Ticker

  handleEvent: (event) ->
    @time = event.time

    try
      if event.msg == 'SYNC'
        @synchronized = true
        @onSync(JSON.parse(event.data))

        clearTimeout(@timeout)
        @timeout = setTimeout(@triggerTimeout, 3000)

      else if @synchronized and event.msg == 'ACTION'
        @onAction(parseInt(event.data[0]), JSON.parse(event.data[1]))
    catch e
      console.log("Error while processing event: ", event.data)
      throw e

  stop: ->
    @stopped = true
    @ticker.clear()
    clearTimeout(@timeout)
    clearTimeout(@timer)

  reset: ->
    @synchronized = false
    @buffer.clear()
    @stop()

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

      # TODO: Think about what happens when the buffer empties

    game_loop()

  triggerEvent: (event) ->
    @onEvent(new MMPG.Event(event.data))

  triggerDisconnect: ->
    @onDisconnect()

  triggerTimeout: =>
    @onTimeout()

  onConnect: ->
  onDisconnect: ->
  onTimeout: ->
  onSync: ->
  onAction: ->
