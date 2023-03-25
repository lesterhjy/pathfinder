import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="trip-form"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log('trip-form connected')
  }

  send(event) {
    document.querySelector("#load").classList.remove("d-none");
    document.querySelector("#search").classList.add("d-none");
  }
}
