const { env } = require('process')

module.exports = {
  test: /\.(jpg|jpeg|png|gif|svg|eot|ttf|woff|woff2)$/i,
  use: [{
    loader: 'file-loader',
    options: {
      context: 'assets',
      name: env.NODE_ENV === 'production' ? '[path][name]-[hash].[ext]' : '[path][name].[ext]'
    }
  }]
}
