describe( 'Top-Level', () ->
  beforeEach(
    module('appTop')
  )
  
  describe( 'Controller', () ->
    beforeEach(inject( ($controller, _$location_, $rootScope) ->
      @location = _$location_
      @scope = $rootScope.$new()
      @ctrl = $controller('appCtrl',
        $scope: @scope
        $location: @location
      )
    ))

    it('should pass a dummy test', () ->
      expect(@ctrl).toBeTruthy()
    )
  )
)
