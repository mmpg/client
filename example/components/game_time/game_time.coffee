angular.module 'mmpgGameTime', []
  .directive 'gameTime', ($mdDialog, $timeout) ->
    restrict: 'E'
    templateUrl: 'components/game_time/controls.html'
    controller: ($scope, Client, EventStream) ->
      $scope.stream = EventStream
      timer = null
      progressInterval = 60 * 60 * 1000
      offset = new Date().getTimezoneOffset() * 60 * 1000

      playbackMode = ->
        if EventStream.subscriber instanceof MMPG.LiveSubscriber
          EventStream.notify(new MMPG.PlaybackSubscriber(Client, EventStream.subscriber))

      amount = (event) ->
        seconds = if event.ctrlKey
          60 * 5
        else if event.altKey
          60 * 15
        else if event.shiftKey
          60 * 60
        else
          60

        seconds * 1000

      apply = (callback) ->
        callback()

        timer = $timeout(->
          apply(callback)
        , 200)

      progress = (time) ->
        ((time - offset) % progressInterval) / progressInterval * 100

      $scope.loaded = ->
        items = EventStream.subscriber.buffer.items
        last = items[items.length - 1]

        if last then progress(last[2]) else 0

      $scope.processed = ->
        progress(EventStream.subscriber.time)

      $scope.stop = (event) ->
        $timeout.cancel(timer)
        event.target.blur()

      $scope.start_rewind = (event) ->
        playbackMode()

        apply ->
          EventStream.subscriber.rewind(amount(event))

      $scope.play_pause = ->
        stopped = EventStream.subscriber.stopped

        playbackMode()

        if stopped
          EventStream.subscriber.play()
        else
          EventStream.subscriber.pause()
