require("@rails/ujs").start()
require("@rails/activestorage").start()
import { Turbo } from "@hotwired/turbo-rails"
window.Turbo = Turbo

import "controllers"
import 'core-js/stable'
import 'regenerator-runtime/runtime'
