import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="directions"
export default class extends Controller {
  static targets = ["directions", "event"]

  connect() {
  }

  showDirections() {

    if (this.directionsTarget.innerText !== "") {
      if (this.directionsTarget.classList.contains("d-none")) {
        this.directionsTargets.forEach((target) => {
          target.classList.remove("d-none")
        })
      } else {
        this.directionsTargets.forEach((target) => {
          target.classList.add("d-none")
        })
      }
    } else {

      this.eventTargets.forEach((eventTarget, index) => {

        // console.log(eventTarget.dataset)
        if (index < this.eventTargets.length - 1) {

          let origin_latitude = parseFloat(eventTarget.parentElement.dataset.latitude)
          let origin_longitude = parseFloat(eventTarget.parentElement.dataset.longitude)
          let destination_latitude = parseFloat(eventTarget.parentElement.nextElementSibling.dataset.latitude)
          let destination_longitude = parseFloat(eventTarget.parentElement.nextElementSibling.dataset.longitude)

          const transport = ['DRIVING', 'TRANSIT', 'WALKING']

          var service = new google.maps.DistanceMatrixService();
          transport.forEach((mode) => {

            service.getDistanceMatrix(
            {
              origins: [{lat: origin_latitude, lng: origin_longitude}],
              destinations: [{lat: destination_latitude, lng: destination_longitude}],
              travelMode: mode,
            },

            (response, status) => {
              let duration = response.rows[0].elements[0].duration.text

              let icon;

              if (mode === 'DRIVING') {
                icon = '<i class="fa-solid fa-car-side"></i>'
              } else if (mode === 'TRANSIT') {
                icon = '<i class="fa-solid fa-train-subway"></i>'
              } else if (mode === 'WALKING') {
                icon = '<i class="fa-solid fa-person-hiking"></i>'
              }


              if (mode === "TRANSIT") {
                mode = "public transport"
              }

              this.directionsTargets[index].innerHTML += `
                <p class="direction"><small>${icon} ${duration}</small></p>
              `
            });
          })
        }

      })

    }

  }


}
