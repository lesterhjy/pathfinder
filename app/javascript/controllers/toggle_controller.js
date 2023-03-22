import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["tab", "events"]

  connect() {
  }

  toggle() {
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

}
