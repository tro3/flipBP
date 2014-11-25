describe( 'About', () ->
  beforeEach(
    module('app.about')
  )

  describe('State', () ->
    beforeEach(inject( ($state) ->
      @state = $state
    ))

    it('should have the proper url', () ->
      expect(@state.get('about').url).toBe('/about')
    )
  )
  
  describe('Controller', () ->
    beforeEach(inject( ($controller, _$location_, $rootScope) ->
      @location = _$location_
      @scope = $rootScope.$new()
      @ctrl = $controller('AboutCtrl',
        $scope: @scope
        $location: @location
      )
    ))

    it('should pass a dummy test', () ->
      expect(@ctrl).toBeTruthy()
    )
  )
)
