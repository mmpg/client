angular.module 'mmpgGameMenu', ['mmpgLogin', 'mmpgUpdateAI']
  .directive 'gameMenu', ->
    restrict: 'E'
    templateUrl: 'components/game_menu/menu.html'
    controller: ($scope, Session) ->
      $scope.session = Session
