import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="trip-form"
export default class extends Controller {
  static targets = ["form", "hidden"]

  connect() {
    console.log('trip-form connected')
  }

  send(event) {
    document.querySelector("#load").classList.remove("d-none");
    document.querySelector("#search").classList.add("d-none");
  }

  toggle() {
    console.log(this.formTarget)
    console.log(this.hiddenTarget)
    if (this.hiddenTarget.classList.contains("d-none")) {
      this.hiddenTarget.classList.remove("d-none")
      // event.target.innerText = "–"
    } else {
      this.hiddenTarget.classList.add("d-none")
      // event.target.innerText = "+"
    }
  }
}
