import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-event"
export default class extends Controller {
  static targets = ["add", "form"]

  connect() {
  }

  create(event) {
    event.preventDefault()
    const url = this.formTarget.action
    fetch(url, {
      method: "PATCH",
      headers: {"Accept": "text/plain"},
      body: new FormData(this.formTarget)
    })
      .then(response => response.text())
      .then((data) => {
      })
    this.addTarget.outerHTML = "<button class='btn-ghost'>Added!</button>"
  }
}
