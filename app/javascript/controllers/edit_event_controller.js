import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-event"
export default class extends Controller {
  static targets = ["card", "form", "info", "sign", "field"]

  connect() {
    // console.log(this.fieldTargets)
    // console.log(this.formTargets)
  }

  displayForm() {
    let current_event = event.target;
    let current_index = this.fieldTargets.indexOf(current_event);
    this.formTargets[current_index].classList.remove('d-none');
    this.fieldTargets[current_index].classList.add('d-none');
  }

  update(event) {
    event.preventDefault()
    let current_event = event.target;
    let current_index = this.formTargets.indexOf(current_event);
    const url = this.formTargets[current_index].action
    fetch(url, {
      method: "PATCH",
      headers: {'Accept': 'text/plain'},
      body: new FormData(this.formTargets[current_index])
    })
    .then(response => response.text())
    .then((data) => {
      let display = this.infoTarget.classList.contains('d-none')
      console.log(display)
      this.cardTarget.innerHTML = data;
      if (display == false) {
        this.infoTarget.classList.remove('d-none');
        this.signTarget.innerText = '–'
      }
    })
  }
}
