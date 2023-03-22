import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="directions"
export default class extends Controller {
  static targets = ["directions", "event", "driving", "walking", "transit"]

  connect() {
  }

  showDirections() {

    if (event.type === "update-directions" && this.directionsTarget.innerText === "") { return }

    // if there is already stuff loaded in the directions div i.e. google has already been called then hide it
    if (this.directionsTarget.innerText !== "" && event.type === "click") { this.wipe() }

    else {
      if (event.type === "update-directions") { this.wipe() }

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
                this.drivingTargets[index].innerHTML = `
                <p class="direction"><small>${icon} ${duration}</small></p>`
              } else if (mode === 'TRANSIT') {
                icon = '<i class="fa-solid fa-train-subway"></i>'
                this.transitTargets[index].innerHTML = `
                <p class="direction"><small>${icon} ${duration}</small></p>`
              } else if (mode === 'WALKING') {
                icon = '<i class="fa-solid fa-person-hiking"></i>'
                this.walkingTargets[index].innerHTML = `
                <p class="direction"><small>${icon} ${duration}</small></p>`
              }
            });
          })
        }

      })

    }

  }

  wipe() {
    this.walkingTargets.forEach((target) => {
      target.innerHTML = ""
    })
    this.drivingTargets.forEach((target) => {
      target.innerHTML = ""
    })
    this.transitTargets.forEach((target) => {
      target.innerHTML = ""
    })
  }


}
