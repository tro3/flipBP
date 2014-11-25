describe( 'Home', () ->
  beforeEach(
    module('app.home')
  )

  describe('State', () ->
    beforeEach(inject( ($state) ->
      @state = $state
    ))

    it('should have the proper url', () ->
      expect(@state.get('home').url).toBe('/')
    )
  )
  
  describe('Controller', () ->
    beforeEach(inject( ($controller, _$location_, $rootScope) ->
      @location = _$location_
      @scope = $rootScope.$new()
      @ctrl = $controller('HomeCtrl',
        $scope: @scope
        $location: @location
      )
    ))

    it('should pass a dummy test', () ->
      expect(@ctrl).toBeTruthy()
    )
  )
)
