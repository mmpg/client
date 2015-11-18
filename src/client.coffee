class Client
  constructor: (@api) ->
    @synchronized = false

  handleEvents: (callbacks) ->
    @events_connection = new WebSocket("ws://#{@api}/events")
    @timeout = setTimeout(callbacks.timeout, 3000)

    @events_connection.onopen = (event) ->
      console.log("WebSocket connected!")

    @events_connection.onclose = =>
      console.log("WebSocket disconnected :(")
      callbacks.disconnect()
      setTimeout(=>
        @handleEvents(callbacks)
      , 5000) # Retry every five seconds

    @events_connection.onmessage = (event) =>
      [msg, data...] = event.data.split(' ')

      if msg == 'SYNC'
        @synchronized = true
        callbacks.sync(JSON.parse(data))
        clearTimeout(@timeout)
        @timeout = setTimeout(callbacks.timeout, 3000)
      else if @synchronized and msg == 'ACTION'
        callbacks.action(parseInt(data[0]), JSON.parse(data[1]))

  login: ({email, password}) ->
    token = undefined

    $.ajax(
      type: 'POST'
      url: "http://#{@api}/auth"
      data: JSON.stringify({ email: email, password: password })
      contentType: 'application/json; charset=utf-8'
      dataType: 'json'
    ).done (data) ->
      token = data

    return token
