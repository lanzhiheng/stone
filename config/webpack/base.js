const webpack = require('webpack')
const { webpackConfig, merge } = require('@rails/webpacker')

const customConfig = {
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery'
    })
  ],
  module: {
    rules: [
      {
        test: [
          /\.bmp$/,
          /\.gif$/,
          /\.jpe?g$/,
          /\.png$/,
          /\.tiff$/,
          /\.ico$/,
          /\.avif$/,
          /\.webp$/,
          /\.eot$/,
          /\.otf$/,
          /\.ttf$/,
          /\.woff$/,
          /\.woff2$/,
          /\.svg$/
        ],
        exclude: [/\.(js|mjs|jsx|ts|tsx)$/],
        type: 'asset/resource',
        generator: {
          filename: function(res) {
            const relatedPath = res.module.rawRequest.slice(2)
            return `media/images/${relatedPath}`
          }
        }
      }
    ]
  }
}

module.exports = merge(webpackConfig, customConfig)
