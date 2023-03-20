import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="directions"
export default class extends Controller {
  static targets = ["directions", "event"]

  connect() {
  }

  showDirections() {

    function getDuration(response, status, mode) {
      let duration = response.rows[0].elements[0].duration.text
      console.log(response.rows[0].elements[0].duration.text)
    }

    this.eventTargets.forEach((eventTarget, index) => {

      // console.log(eventTarget.dataset)
      if (index < this.eventTargets.length - 1) {

        let origin_latitude = parseFloat(eventTarget.parentElement.dataset.latitude)
        let origin_longitude = parseFloat(eventTarget.parentElement.dataset.longitude)
        let destination_latitude = parseFloat(eventTarget.parentElement.nextElementSibling.dataset.latitude)
        let destination_longitude = parseFloat(eventTarget.parentElement.nextElementSibling.dataset.longitude)

        console.log(origin_latitude, origin_longitude, destination_latitude, destination_longitude)

        this.durations = {}
        const transport = ['DRIVING', 'WALKING', 'TRANSIT']

        var service = new google.maps.DistanceMatrixService();
        transport.forEach((mode) => {
          service.getDistanceMatrix(
          {
            origins: [{lat: origin_latitude, lng: origin_longitude}],
            destinations: [{lat: destination_latitude, lng: destination_longitude}],
            travelMode: mode,
          }, getDuration({mode: mode}));
        })
      }

    })
  }


}
