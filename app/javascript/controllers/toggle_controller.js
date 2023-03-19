import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["tab", "events"]

  connect() {
  }

  toggle() {
    console.log(event.target.dataset.toggleUrl)
    this.request = new Request(event.target.dataset.toggleUrl);
    this.fetchContent(this.request);
  }

  fetchContent(request) {
    fetch(request)
      .then((response) => {
        if (response.status == 200) {
          response.text().then((text) =>
          this.eventsTarget.innerHTML = text);
        } else {
          console.log("Couldn't load data");
        }
      })
  }

}
