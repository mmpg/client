class MMPG.GameLoop
  constructor: (ticks_per_second) ->
    @entities = []
    @interval = 1.0 / ticks_per_second
    @ticker = new MMPG.Ticker

  start: =>
    @ticker.tick()

    while @ticker.accum >= @interval
      for entity in @entities
        entity.update(@interval)

      @ticker.accum -= @interval

    setTimeout(@start, @interval - @ticker.accum)
