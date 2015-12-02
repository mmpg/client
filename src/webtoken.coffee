class MMPG.Webtoken
  constructor: (@string) ->
    @payload = JSON.parse(atob(@string.split('.')[1]))
