require("@rails/ujs").start()
require("@rails/activestorage").start()
import { Turbo } from "@hotwired/turbo-rails"
window.Turbo = Turbo

import $ from 'jquery'
import 'select2/dist/js/select2.full.js'
import "controllers"
import 'core-js/stable'
import 'regenerator-runtime/runtime'

import 'tailwindcss/dist/utilities.css';
