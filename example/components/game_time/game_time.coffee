angular.module 'mmpgGameTime', []
  .directive 'gameTime', ($mdDialog, $timeout) ->
    restrict: 'E'
    templateUrl: 'components/game_time/controls.html'
    controller: ($scope, EventStream) ->
      $scope.stream = EventStream
      originalSubscriber = EventStream.subscriber
      playbackSubscriber = new MMPG.PlaybackSubscriber

      timer = null

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
        playbackSubscriber.time = EventStream.subscriber.time
        EventStream.notify(playbackSubscriber)

        apply ->
          playbackSubscriber.time -= amount(event)

      $scope.play = ->
        EventStream.subscriber.play()
