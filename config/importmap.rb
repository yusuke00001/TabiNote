# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "preview_image", to: "preview_image.js"
pin "@rails/ujs", to: "@rails--ujs.js" # @7.1.3
pin "flatpickr" # @4.6.13
pin "flatpickr/calendarpickr", to: "flatpickr/calendarpickr.js"
pin "flatpickr/timepickr", to: "flatpickr/timepickr.js"
pin "selected_plan", to: "selected_plan.js"
