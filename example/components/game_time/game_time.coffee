angular.module 'mmpgGameTime', []
  .directive 'gameTime', ($mdDialog) ->
    restrict: 'E'
    templateUrl: 'components/game_time/controls.html'
    controller: ($scope, EventStream) ->
      $scope.stream = EventStream
