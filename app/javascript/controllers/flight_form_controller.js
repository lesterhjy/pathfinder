import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flight-form"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log(this.element)
    console.log(this.formTarget)
  }

  send(event) {
    event.preventDefault()
    fetch(this.formTarget.action, {
      method: "POST",
      headers: { "Accept": "application/json" },
      body: new FormData(this.formTarget)
    })
      .then(response => {
        console.log(response)
        return response.json()
      })
      .then((data) => {
        this.formTarget.outerHTML = data.form

      })
  }
}
