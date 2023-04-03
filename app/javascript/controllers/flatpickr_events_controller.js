import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr-events"
export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: false,
      minDate: false,
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d"
    });
  }
}
