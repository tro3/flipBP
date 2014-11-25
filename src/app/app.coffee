angular.module( 'appTop', [
  'templates'
  'app.home'
  'app.about'
  'ui.router'
])

.config( ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise('/')
)

.run( () ->
)

.controller('appCtrl', ($scope, $location) ->
)
