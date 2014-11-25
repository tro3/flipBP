angular.module( 'app.home', [
  'ui.router'
])

.config(($stateProvider) ->
  $stateProvider.state('home',
    url: '/'
    controller: 'HomeCtrl'
    templateUrl: 'home/home.tpl.html'
  )
)

.controller('HomeCtrl', ($scope) ->
  $scope.test = "They're here..."
)
