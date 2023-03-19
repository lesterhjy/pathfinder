import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-event"
export default class extends Controller {
  static targets = ["add", "form"]

  connect() {
    console.log(this.formTarget)
  }

  create(event) {
    event.preventDefault()
    const url = this.formTarget.action
    fetch(url, {
      method: "POST",
      headers: {"Accept": "text/plain"},
      body: new FormData(this.formTarget)
    })
      .then(response => response.text())
      .then((data) => {
      })
    this.addTarget.outerHTML = "<p class='btn-ghost'>Added!</p>"
  }
}
