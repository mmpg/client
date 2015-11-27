class MMPG.LiveSubscriber extends MMPG.Subscriber
  onEvent: (event) ->
    @buffer.add(event, parseInt(event.data.split(' ')[0]))
    @start() if @stopped and @buffer.isReady()

  triggerTimeout: =>
    @onTimeout()
    @reset()
