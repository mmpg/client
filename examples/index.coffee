$ ->
  client = new Client('localhost:8080')

  client.handleEvents (event) ->
    console.log(event)
