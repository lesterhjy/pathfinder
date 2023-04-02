import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="events-loader"
export default class extends Controller {
  static targets = ["events"]

  connect() {
    console.log("events-loader connected")
    console.log(this.eventsTarget.innerHTML)
    setInterval(this.fetchFun, 1000)
  }

  fetchFun() {
    const url = document.URL

    fetch(url, {
      method: "GET",
      headers: { "Accept": "text/plain" }
    })
      .then(response => response.text())
      .then((data) => {
        const eventList = document.querySelector("#event-list")
        eventList.innerHTML = data
      })
  }
}
