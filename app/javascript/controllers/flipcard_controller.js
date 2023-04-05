import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flipcard"
export default class extends Controller {
  static targets = ["card"]

  connect() {
    console.log("flipcard connected")
  }

  flip() {
    this.cardTarget.classList.add("isflipped")
  }
}
