class MMPG.PlaybackSubscriber extends MMPG.Subscriber
  constructor: (@client, @liveSubscriber) ->
    super()
    @time = @liveSubscriber.time
    @loading = false
    @loadProgress = 0
    @onSync = @liveSubscriber.onSync
    @onAction = @liveSubscriber.onAction

  onEvent: (event) ->
    @maxTime = event.time

  rewind: (amount) ->
    @time -= amount
    @reset()

  forward: (amount) ->
    @time = Math.min(@maxTime, @time + amount)
    @reset()

  play: ->
    if @synchronized then @start() else @loadBufferAndStart()

  loadBufferAndStart: ->
    @loading = true

    promise = @client.log @time, (progress) =>
      @loadProgress = progress

    promise.done (log) =>
      for data in log.split('\n')
        event = new MMPG.Event(data)
        @buffer.add(event, event.time) if event.time >= @time

      @loading = false
      @start()

  pause: ->
    @stop()
