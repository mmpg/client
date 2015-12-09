angular.module 'mmpgViewer', [
  'ngMaterial', 'ngMessages', 'ngStorage',
  'mmpgClient', 'mmpgDebug', 'mmpgGameViewer',
  'mmpgGameTime', 'mmpgGameMenu'
]
  .config ($mdThemingProvider) ->
    $mdThemingProvider.theme('default')
      .dark()
      .backgroundPalette('grey', default: '900')
      .foregroundPalette['3'] = 'rgba(198,198,198,0.9)'

  .run ($interval) ->
    $interval((->), 333)
