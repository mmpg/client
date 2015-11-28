class MMPG.LiveSubscriber extends MMPG.Subscriber
  onEvent: (event) ->
    @buffer.add(event, event.time)
    @start() if @stopped and @buffer.isReady()

  triggerTimeout: =>
    @onTimeout()
    @reset()
