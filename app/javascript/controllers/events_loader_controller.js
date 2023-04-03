import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="events-loader"
export default class extends Controller {
  static targets = ["events"]

  connect() {
    console.log("events-loader connected")
    console.log(this.eventsTarget.innerHTML)
    this.fetchInterval(this.fetchFun, 3000, 10)
  }

  fetchInterval(callback, delay, repetitions) {
    var runs = 0
    var intervalID = setInterval(function () {
      callback()
      if (++runs === repetitions) {
        clearInterval(intervalID);
        document.querySelector("#event-loader").classList.add("d-none");
      }
    }, delay)
  }

  fetchFun() {
    console.log("running")
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
