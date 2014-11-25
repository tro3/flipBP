// Karma configuration
// http://karma-runner.github.io/0.10/config/configuration-file.html

module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    preprocessors: {
      '*/.html': [],
      '**/*.coffee': ['coffee']
    },
    exclude: [],
    reporters: ['dots'],
    logLevel: config.LOG_INFO,
    autoWatch: false,
    browsers: ['Chrome']

  });
};