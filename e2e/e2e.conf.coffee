require('coffee-script')

exports.config =
    directConnect: true
    chromeDriver: '../node_modules/grunt-protractor-runner/node_modules/protractor/selenium/chromedriver'

    capabilities:
        browserName: 'chrome'

    specs: [
        '**/*.coffee'
    ]

    baseUrl: 'http://localhost:8000'

    framework: 'jasmine'
    
    jasmineNodeOpts:
        showColors: true,
        defaultTimeoutInterval: 30000