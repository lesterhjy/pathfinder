import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="maps"
export default class extends Controller {
  static targets = ["map", "longitude", "latitude"];

  connect() {
    this.labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    this.labelIndex = 0;
    if (typeof(google) != "undefined") {
      this.initMap()
    }
  }

  initMap() {
    this.map = new google.maps.Map(this.mapTarget, {
      center: {lat: parseFloat(this.latitudeTarget.innerText), lng: parseFloat(this.longitudeTarget.innerText) },
      zoom: 15
    });

    this.latitudeTargets.forEach((latitude, index) => {
      const longitude = this.longitudeTargets[index]
      new google.maps.Marker({
        map: this.map,
        position: { lat: parseFloat(latitude.innerText), lng: parseFloat(longitude.innerText)},
        label: this.labels[this.labelIndex++ % this.labels.length]
      })
    })


  }
}
