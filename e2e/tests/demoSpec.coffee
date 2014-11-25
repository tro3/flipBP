
describe('demo', () ->
    beforeEach( ->
        browser.get('/build')
    )

    it('should contain the jumbotron', () ->
        expect(element(By.css('.jumbotron'))).toBeTruthy()
    )
)
