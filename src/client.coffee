window.MMPG = {}

class MMPG.Client
  constructor: (@api) ->

  eventStream: ->
    new MMPG.EventStream("#{@api}/events")

  setAuth: (token) ->
    $.ajaxSetup
      headers:
        Authorization: token

  login: ({email, password}) ->
    $.ajax(
      type: 'POST'
      url: "http://#{@api}/auth"
      data: JSON.stringify({ email: email, password: password })
      contentType: 'application/json; charset=utf-8'
    )

  renew: (token) ->
    $.ajax(
      type: 'GET',
      url: "http://#{@api}/auth"
    )

  deploy: (player, progressCallback) ->
    data = new FormData
    data.append('player', player)

    $.ajax(
      type: 'POST'
      url: "http://#{@api}/player"
      data: data
      cache: false
      processData: false
      xhr: ->
        xhr = $.ajaxSettings.xhr()

        if xhr.upload
          xhr.upload.onprogress = (event) ->
            if progressCallback and event.lengthComputable
              progressCallback(event.loaded / event.total * 100)

        return xhr
    )

  log: (time, progressCallback) ->
    $.ajax(
      type: 'GET'
      url: "http://#{@api}/log"
      data: { time: Math.floor(time / 1000) }
      xhr: ->
        xhr = $.ajaxSettings.xhr()

        xhr.onprogress = (event) ->
          if progressCallback and event.lengthComputable
            progressCallback(event.loaded / event.total * 100)

        return xhr
    )
