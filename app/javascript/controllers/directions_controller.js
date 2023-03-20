import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="directions"
export default class extends Controller {
  static targets = ["directions", "event"]

  connect() {
  }

  showDirections() {
    this.eventTargets.forEach((eventTarget, index) => {
      // console.log(eventTarget.dataset)
      if (index < this.eventTargets.length - 1) {
        let origin_latitude = eventTarget.parentElement.dataset.latitude
        let origin_longitude = eventTarget.parentElement.dataset.longitude
        let destination_latitude = eventTarget.parentElement.nextElementSibling.dataset.latitude
        let destination_longitude = eventTarget.parentElement.nextElementSibling.dataset.longitude

        console.log(origin_latitude, origin_longitude, destination_latitude, destination_longitude)
      }

    })
  }


}
