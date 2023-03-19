import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["tab", "events"]

  connect() {
  }

  toggle() {
    const url = event.target.dataset.toggleUrl
    fetch(url, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then((data) => {
        this.eventsTarget.outerHTML = data
      })
  }

}
