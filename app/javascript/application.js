// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import flatpickr from "flatpickr"
import "./controllers"
import "bootstrap"

window.initMap = function(...args) {
  const event = document.createEvent("Events")
  event.initEvent("google-maps-callback", true, true)
  event.args = args
  window.dispatchEvent(event)
}

flatpickr(".datetimepicker", {
  enableTime: true,
  dateFormat: "Y-m-d H:i",
  altInput: true,
  altFormat: "j M Y, h.i K",
  minDate: "today"
})

flatpickr(".trip-recommendation-datetimepicker", {
  enableTime: false,
  minDate: false,
  altInput: true,
  altFormat: "F j, Y",
  dateFormat: "Y-m-d"
})
