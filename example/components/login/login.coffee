angular.module 'mmpgLogin', []
  .directive 'login', ($mdDialog) ->
    restrict: 'A'
    link: (scope, element) ->
      element.on 'click', (event) ->
        $mdDialog.show
          parent: angular.element(document.body)
          targetEvent: event
          templateUrl: 'components/login/form.html'
          clickOutsideToClose: true
          controller: (scope) ->
            scope.close = ->
              $mdDialog.hide()
