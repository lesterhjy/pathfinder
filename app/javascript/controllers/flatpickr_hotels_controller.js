import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr-hotels"
export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      altInput: true,
      altFormat: "j M Y, h.i K",
      minDate: "today"
    });
  }
}
