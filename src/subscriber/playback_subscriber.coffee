class MMPG.PlaybackSubscriber extends MMPG.Subscriber
  constructor: (@liveSubscriber) ->
    super()
    @time = @liveSubscriber.time

  onEvent: (event) ->

  play: ->
    @stopped = false

  pause: ->
    @stopped = true
