class MMPG.Event
  constructor: (data) ->
    [@time, @msg, @data...] = data.split(' ')
