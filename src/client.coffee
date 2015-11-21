class Client
  constructor: (@api) ->
    @synchronized = false
    @game = new Game(30)

  handleEvents: (callbacks) ->
    @events_connection = new WebSocket("ws://#{@api}/events")
    @timeout = setTimeout(callbacks.timeout, 3000)
    @last = undefined

    @events_connection.onopen = (event) ->
      console.log("WebSocket connected!")

    @events_connection.onclose = =>
      console.log("WebSocket disconnected :(")
      callbacks.disconnect()
      @synchronized = false
      @game.reset()
      setTimeout(=>
        @handleEvents(callbacks)
      , 5000) # Retry every five seconds

    handleEvent = (event) =>
      [time, msg, data...] = event.data.split(' ')

      if msg == 'SYNC'
        @synchronized = true
        callbacks.sync(JSON.parse(data))
        clearTimeout(@timeout)
        @timeout = setTimeout(=>
          callbacks.timeout()
          @synchronized = false
          @last = undefined
          @game.reset()
        , 3000)
      else if @synchronized and msg == 'ACTION'
        callbacks.action(parseInt(data[0]), JSON.parse(data[1]))

    @events_connection.onmessage = (event) =>
      console.log(event)
      now = parseInt(event.data.split(' ')[0])
      diff = if @last then now - @last else 0
      @last = now

      size = @game.buffer.push([event, diff])

      if @game.stopped and @game.is_ready()
        @game.play(handleEvent)

  login: ({email, password}) ->
    $.ajax(
      type: 'POST'
      url: "http://#{@api}/auth"
      data: JSON.stringify({ email: email, password: password })
      contentType: 'application/json; charset=utf-8'
      dataType: 'json'
    )
