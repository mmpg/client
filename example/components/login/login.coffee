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
              Api.login($scope.user)
                .done (token) ->
                  alert('Valid credentials')
                .fail (e, b, error) ->
                  console.log(error)
                  alert('Invalid credentials')
