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
            tasks =
              upload:
                description: 'Uploading new code...'
                tip: 'Be sure that your internet connection is working properly.'
                progress: 0
              compilation:
                description: 'Compiling update...'
              installation:
                description: 'Installing update...'
              restart:
                description: 'Restarting ship systems...'

            $scope.tasks = [
              tasks.upload
              tasks.compilation
              tasks.installation
              tasks.restart
            ]

            $scope.reset = ->
              tasks.upload.progress = 0

              for _, task of tasks
                task.status = 'pending'

            $scope.reset()

            $scope.close = ->
              $mdDialog.hide()

            $scope.fileIsInvalid = ->
              !$scope.file

            $scope.deploy = ->
              $scope.reset()
              tasks.upload.status = 'working'

              Client.deploy($scope.file, (progress) ->
                tasks.upload.progress = progress
                tasks.upload.status = 'done' if progress == 100
              )
                .done ->
                  for _, task of tasks
                    task.status = 'done'

                .fail ->
                  if tasks.upload.status == 'working'
                    tasks.upload.status = 'error'
                  else
                    tasks.compilation.status = 'error'

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
