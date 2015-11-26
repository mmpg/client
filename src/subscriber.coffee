class MMPG.Subscriber
  constructor: ->
    @synchronized = false
    @buffer = new MMPG.Buffer(60, @handleEvent)
    @last_tick = 0
    @last_item = 0

  handleEvent: (event) =>
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
    @buffer.clear()
    clearTimeout(@timeout)

  triggerDisconnect: ->
    @onDisconnect()
  triggerTimeout: ->
    @onTimeout()

  onConnect: ->
  onDisconnect: ->
  onTimeout: ->
  onSync: ->
  onAction: ->
