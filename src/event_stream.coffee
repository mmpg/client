class MMPG.EventStream
  constructor: (@uri) ->

  notify: (subscriber) ->
    @subscriber.reset() if @subscriber
    @subscriber = subscriber

  connect: =>
    @connection = new WebSocket("ws://#{@uri}")

    @connection.onopen = (event) =>
      console.log("WebSocket connected!")
      @subscriber.onConnect()

    @connection.onclose = =>
      console.log("WebSocket disconnected :(")
      @subscriber.triggerDisconnect()
      setTimeout(@connect, 5000) # Retry every five seconds

    @connection.onmessage = (event) =>
      @subscriber.onEvent(event)

  disconnect: ->
    @connection.close()
