angular.module 'mmpgClient', []
  .service 'Client', ->
    new MMPG.Client(window.location.hostname + ':8080')

  .service 'EventStream', (Client) ->
    Client.eventStream()
