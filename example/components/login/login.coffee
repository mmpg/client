angular.module 'mmpgLogin', []
  .directive 'login', ($mdDialog, Api) ->
    restrict: 'A'
    link: (scope, element) ->
      element.on 'click', (event) ->
        $mdDialog.show
          parent: angular.element(document.body)
          targetEvent: event
          templateUrl: 'components/login/form.html'
          clickOutsideToClose: true
          controller: ($scope) ->
            $scope.user = { email: '', password: '' }
            $scope.login = ->
              token = Api.login($scope.user)

              if token
                alert('Valid credentials')
              else
                alert('Invalid credentials')
