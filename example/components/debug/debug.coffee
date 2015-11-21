angular.module 'mmpgDebug', []
  .directive 'debug', ->
    restrict: 'E'
    templateUrl: 'components/debug/overlay.html'
    controller: ($scope, Api) ->
      $scope.game = Api.game
      apply = ->
        $scope.$apply(->)
        setTimeout(apply, 500)

      setTimeout(apply, 500)
