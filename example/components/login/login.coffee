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
            $scope.invalidCredentials = false

            $scope.formInvalid = ->
              $scope.loginForm?.$invalid || $scope.loginForm?.email?.$error?.credentials

            $scope.semaphorImage = ->
              if $scope.loading
                'semafor_orange.png'
              else if $scope.formInvalid()
                'semafor_red.png'
              else
                'semafor.png'

            $scope.cleanCredentialsError = ->
              delete $scope.loginForm.email.$error.credentials
              delete $scope.loginForm.password.$error.credentials
              $scope.loginForm.email.$$parseAndValidate()
              $scope.loginForm.password.$$parseAndValidate()

            $scope.login = ->
              $scope.loading = true

              Client.login($scope.user)
                .done (token) ->
                  alert('Valid credentials')
                .fail (e, b, error) ->
                  $scope.loginForm.email.$error.credentials = true
                  $scope.loginForm.password.$error.credentials = true
                  $scope.loginForm.email.$$parseAndValidate()
                  $scope.loginForm.password.$$parseAndValidate()
                .always ->
                  $scope.loading = false
