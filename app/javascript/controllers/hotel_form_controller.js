import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hotel-form"
export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log(this.element)
    console.log(this.formTarget)
  }

  send(event) {
    event.preventDefault();
    fetch(this.formTarget.action, {
      method: "POST",
      headers: { Accept: "text/plain" },
      body: new FormData(this.formTarget),
    })
      .then((response) => response.text())
      .then((data) => {
        if (data) {
          this.formTarget.outerHTML = data;
        } else {
          window.location.reload();
        }
      });
  }
}
