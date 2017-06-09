// Note: You must restart bin/webpack-dev-server for changes to take effect

const merge = require('webpack-merge')
const sharedConfig = require('./shared.js')

module.exports = merge(sharedConfig, {
  devtool: 'cheap-eval-source-map',

  output: {
    pathinfo: true
  }
})
