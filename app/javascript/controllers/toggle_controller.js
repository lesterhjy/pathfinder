import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["tab", "day"]

  connect() {
  }

  toggle() {
    const day_clicked = event.target.dataset.day
    this.dayTargets.forEach((day) => {
      if (day.dataset.day === day_clicked) {
        day.classList.remove("d-none")
      } else {
        day.classList.add("d-none")
      }
    })
  }

}
