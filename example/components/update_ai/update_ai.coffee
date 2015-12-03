angular.module 'mmpgUpdateAI', []
  .directive 'updateAi', ($mdDialog) ->
    restrict: 'A'
    link: (scope, element) ->
      element.on 'click', (event) ->
        event.delegateTarget.blur()
        $mdDialog.show
          parent: angular.element(document.body)
          targetEvent: event
          templateUrl: 'components/update_ai/form.html'
          clickOutsideToClose: true
          disableParentScroll: false
          controller: ($scope, Client) ->
            $scope.close = ->
              $mdDialog.hide()

            $scope.fileIsInvalid = ->
              !$scope.file

            $scope.tasks = [
              { description: 'Uploading new code...', status: 'pending' }
              { description: 'Compiling update...', status: 'pending' }
              { description: 'Installing update...', status: 'pending' }
              { description: 'Restarting ship systems...', status: 'pending' }
            ]

  .directive 'browseFiles', ->
    restrict: 'A'
    scope:
      file: '=browseFiles'
    link: (scope, element, attrs) ->
      fileInput = $('<input type="file"></input>')

      fileInput.bind 'change', (event) ->
        scope.file = event.delegateTarget.files[0]

      element.bind 'click', ->
        fileInput.click()
