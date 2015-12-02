angular.module 'mmpgUpdateAI', []
  .directive 'updateAi', ($mdDialog) ->
    restrict: 'A'
    link: (scope, element) ->
      element.on 'click', (event) ->
        $mdDialog.show
          parent: angular.element(document.body)
          targetEvent: event
          templateUrl: 'components/update_ai/form.html'
          clickOutsideToClose: true
          disableParentScroll: false
          controller: ($scope, Client) ->
            

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
