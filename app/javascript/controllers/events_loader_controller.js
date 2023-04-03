import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="events-loader"
export default class extends Controller {
  static targets = ["events"]

  connect() {
    console.log("events-loader connected")
    this.fetchInterval(this.fetchFun, 1000, 40)
    setTimeout(this.loadedCard, 42000)
  }

  fetchInterval(callback, delay, repetitions) {
    var runs = 0
    var intervalID = setInterval(function () {
      callback()
      runs += 1
      if (runs > repetitions) {
        clearInterval(intervalID);
      }
    }, delay)
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

  loadedCard() {
    document.querySelector("#events-loader").classList.add("d-none");
    document.querySelector("#events-loaded").classList.remove("d-none");
    const eventsCard = document.querySelectorAll(".recommendation-card-loading")
    eventsCard.forEach((card) => {
      card.classList.remove("recommendation-card-loading")
      card.classList.add("recommendation-card")
    })
  }
}
