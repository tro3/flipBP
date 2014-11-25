# FlipBP

A boilerplate project for the Flip web framework


# App setup

[Angular Best Practice Guidelines for Project Structure](http://blog.angularjs.org/2014/02/an-angularjs-style-guide-and-best.html)

```
npm install

bower install

node_modules/grunt-protractor-runner/node_modules/.bin/webdriver-manager update

<modify deploy_dir in build.config.js>
<add live reload if needed>

grunt watch or grunt build

python e2e\testserver.py
grunt e2e

grunt compile

grunt deploy
```
