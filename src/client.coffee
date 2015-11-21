class Client
  constructor: (@api) ->
    @synchronized = false

  handleEvents: (callbacks) ->
    @events_connection = new WebSocket("ws://#{@api}/events")
    @timeout = setTimeout(callbacks.timeout, 3000)
    @buffer = []
    @last = undefined

    @events_connection.onopen = (event) ->
      console.log("WebSocket connected!")

    @events_connection.onclose = =>
      console.log("WebSocket disconnected :(")
      callbacks.disconnect()
      setTimeout(=>
        @handleEvents(callbacks)
      , 5000) # Retry every five seconds

    consumeEvent = =>
      console.log(@buffer.length)
      handleEvent(@buffer.shift()) if @buffer.length > 0

    handleEvent = (event) =>
      if @buffer.length > 0
        next = @buffer.shift()

        setTimeout(->
          handleEvent(next[0])
        , next[1])

      [time, msg, data...] = event.data.split(' ')

      if msg == 'SYNC'
        @synchronized = true
        callbacks.sync(JSON.parse(data))
        clearTimeout(@timeout)
        @timeout = setTimeout(callbacks.timeout, 3000)
      else if @synchronized and msg == 'ACTION'
        callbacks.action(parseInt(data[0]), JSON.parse(data[1]))

    @events_connection.onmessage = (event) =>
      now = parseInt(event.data.split(' ')[0])
      diff = if @last then now - @last else 0
      @last = now

      size = @buffer.push([event, diff])

      if not @synchronized and size > 30
        handleEvent(@buffer.shift()[0])

  login: ({email, password}) ->
    $.ajax(
      type: 'POST'
      url: "http://#{@api}/auth"
      data: JSON.stringify({ email: email, password: password })
      contentType: 'application/json; charset=utf-8'
      dataType: 'json'
    )
