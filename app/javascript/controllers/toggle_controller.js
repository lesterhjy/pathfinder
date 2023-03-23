import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["tab", "events", "info", "event"]

  connect() {
    console.log(this.infoTarget)
  }

  toggleTabs() {
    this.tabTargets.forEach((tab, index) => {
      if (index == event.target.dataset.index) {
        tab.classList.add("tab-active")
      } else {
        tab.classList.remove("tab-active")
      }
    })

    const url = event.target.dataset.toggleUrl
    fetch(url, {headers: {"Accept": "text/plain"}})
      .then(response => response.text())
      .then((data) => {
        this.eventsTarget.outerHTML = data
        const e = new CustomEvent("update-events");
        window.dispatchEvent(e);
      })
  }

  toggleInfo() {
    let current_event = event.target.parentElement.parentElement;
    let current_index = this.eventTargets.indexOf(current_event);
    let current_info_target = this.infoTargets[current_index]
    if (current_info_target.classList.contains("d-none")) {
      current_info_target.classList.remove("d-none")
      event.target.innerText = "–"
    } else {
      current_info_target.classList.add("d-none")
      event.target.innerText = "+"
    }
  }

}
