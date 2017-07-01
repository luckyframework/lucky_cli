/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within assets/js and only use this file to reference
// that code so it'll be compiled.

// Reference script files like this. Note the extension is not required.
// import 'js/my_code'

import 'rails-ujs'
import Turbolinks from 'turbolinks'
Turbolinks.start()

// Require all image files in assets/images
require.context('./images', true, /\./)

// If you add other folders in /assets, make sure to require them like this:
// require.context('./other_folder', true, /\./)

// Require the main css file
require('css/app')
