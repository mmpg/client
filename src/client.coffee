class Client
  constructor: (@api) ->

  handleEvents: (callback) ->
    @events_connection = new WebSocket("ws://#{@api}/events")

    @events_connection.onopen = (event) ->
      console.log("WebSocket connected!")

    @events_connection.onclose = =>
      console.log("WebSocket disconnected :(")
      setTimeout(=>
        @handleEvents(callback)
      , 5000) # Retry every five seconds

    @events_connection.onmessage = callback
