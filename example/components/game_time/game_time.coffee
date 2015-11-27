angular.module 'mmpgGameTime', []
  .directive 'gameTime', ($mdDialog, $timeout) ->
    restrict: 'E'
    templateUrl: 'components/game_time/controls.html'
    controller: ($scope, EventStream) ->
      $scope.stream = EventStream
      timer = null

      playbackMode = ->
        if EventStream.subscriber instanceof MMPG.LiveSubscriber
          EventStream.notify(new MMPG.PlaybackSubscriber(EventStream.subscriber))

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

      $scope.stop = (event) ->
        $timeout.cancel(timer)
        event.target.blur()

      $scope.start_rewind = (event) ->
        playbackMode()

        apply ->
          EventStream.subscriber.time -= amount(event)

      $scope.play_pause = ->
        stopped = EventStream.subscriber.stopped

        playbackMode()

        if stopped
          EventStream.subscriber.play()
        else
          EventStream.subscriber.pause()
