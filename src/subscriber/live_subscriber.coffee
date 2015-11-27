class MMPG.LiveSubscriber extends MMPG.Subscriber
  onEvent: (event) ->
    @buffer.add(event, parseInt(event.data.split(' ')[0]))
    @loaded = Math.min(100, (@buffer.items.length / @buffer.size) * 100)
    @start() if @stopped and @buffer.isReady()

  triggerTimeout: =>
    @onTimeout()
    @reset()
