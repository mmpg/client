angular.module 'mmpgApi', []
  .service 'Api', ->
    new Client(window.location.hostname + ':8080')
