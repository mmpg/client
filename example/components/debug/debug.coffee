angular.module 'mmpgDebug', []
  .directive 'debug', ->
    restrict: 'E'
    templateUrl: 'components/debug/overlay.html'
    controller: ($scope, $timeout, EventStream) ->
      $scope.stream = EventStream
