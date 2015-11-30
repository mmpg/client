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
          disableParentScroll: false
          controller: ($scope, Client) ->
            $scope.user = { email: '', password: '', remember: false }
            $scope.loading = false

            $scope.login = ->
              $scope.loading = true

              Client.login($scope.user)
                .done (token) ->
                  alert('Valid credentials')
                .fail (e, b, error) ->
                  console.log(error)
                  alert('Invalid credentials')
                .always ->
                  $scope.loading = false
