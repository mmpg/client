class MMPG.Ticker
  constructor: ->
    @clear()

  tick: ->
    current_tick = Date.now()
    @last_tick = current_tick if @last_tick == 0
    @accum += current_tick - @last_tick
    @last_tick = current_tick

  clear: ->
    @last_tick = 0
    @accum = 0
