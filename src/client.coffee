class Client
  constructor: (@api) ->
    @synchronized = false

  handleEvents: (syncCallback, actionCallback) ->
    @events_connection = new WebSocket("ws://#{@api}/events")

    @events_connection.onopen = (event) ->
      console.log("WebSocket connected!")

    @events_connection.onclose = =>
      console.log("WebSocket disconnected :(")
      setTimeout(=>
        @handleEvents(callback)
      , 5000) # Retry every five seconds

    @events_connection.onmessage = (event) =>
      [msg, data...] = event.data.split(' ')

      if msg == 'SYNC'
        @synchronized = true
        syncCallback(JSON.parse(data))
      else if @synchronized and msg == 'ACTION'
        actionCallback(parseInt(data[0]), JSON.parse(data[1]))
