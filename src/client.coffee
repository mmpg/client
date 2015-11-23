window.MMPG = {}

class MMPG.Client
  constructor: (@api) ->

  eventStream: ->
    new MMPG.EventStream("#{@api}/events")

  login: ({email, password}) ->
    $.ajax(
      type: 'POST'
      url: "http://#{@api}/auth"
      data: JSON.stringify({ email: email, password: password })
      contentType: 'application/json; charset=utf-8'
      dataType: 'json'
    )
