const { env } = require('process')
const path = require('path')
const glob = require('glob')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const ManifestPlugin = require('webpack-manifest-plugin')
const UglifyJSPlugin = require('uglifyjs-webpack-plugin')

const loadersDir = path.join(__dirname, 'loaders')
const outputFilenameCSS = env.NODE_ENV === 'production' ? '[name]-[hash].css' : '[name].css'
const loaders = glob.sync(path.join(loadersDir, '*.js')).map(loader => require(loader))

module.exports = {
  entry: {
    app: [
      './assets/app.js',
    ],
  },
  output: {
    filename: '[name].js',
    path: path.resolve('public'),
    publicPath: '/'
  },
  plugins: [
    new ExtractTextPlugin(outputFilenameCSS),
    new UglifyJSPlugin(),
    new ManifestPlugin({
      writeToFileEmit: true
    })
  ],
  module: {
    rules: loaders
  },
  resolve: {
    extensions: ['.css', '.sass', '.scss', '.js', '.jsx', '.coffee', '.vue', '.ts'],
    modules: [
      path.resolve('assets'),
      'node_modules'
    ]
  },
  resolveLoader: {
    modules: ['node_modules']
  }
}
