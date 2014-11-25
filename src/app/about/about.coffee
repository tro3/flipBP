angular.module( 'app.about', [
  'ui.router'
])

.config(($stateProvider) ->
  $stateProvider.state('about',
    url: '/about'
    controller: 'AboutCtrl'
    templateUrl: 'about/about.tpl.html'
  )
)



.controller('AboutCtrl', ($scope) ->
)
