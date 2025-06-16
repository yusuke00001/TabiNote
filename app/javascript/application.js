// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "preview_image"
import Rails from "@rails/ujs"
import "flatpickr/calendarpickr"
import "flatpickr/timepickr"
import "selected_plan"
Rails.start()