import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-event"
export default class extends Controller {
  static targets = ["card", "form", "info", "sign"]

  connect() {
  }

  displayForm() {
    this.formTarget.classList.remove('d-none');
  }

  update(event) {
    event.preventDefault()
    const url = this.formTarget.action
    fetch(url, {
      method: "PATCH",
      headers: {'Accept': 'text/plain'},
      body: new FormData(this.formTarget)
    })
    .then(response => response.text())
    .then((data) => {
      this.cardTarget.innerHTML = data;
      this.infoTarget.classList.remove('d-none');
      this.signTarget.innerText = '–'
    })
  }
}
