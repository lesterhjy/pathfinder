import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="maps"
export default class extends Controller {
  static targets = ["map", "event", "longitude", "latitude"];

  connect() {
    this.labels = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (typeof(google) != "undefined") {
      this.initMap()
    }
  }

  initMap() {
    this.bounds = new google.maps.LatLngBounds();

    this.map = new google.maps.Map(this.mapTarget, {
      center: {lat: parseFloat(this.latitudeTarget.innerText), lng: parseFloat(this.longitudeTarget.innerText) },
      zoom: 15
    });
    this.labelIndex = 0;

    this.latitudeTargets.forEach((latitude, index) => {
      const longitude = this.longitudeTargets[index]
      var marker = new google.maps.Marker({
        map: this.map,
        position: { lat: parseFloat(latitude.innerText), lng: parseFloat(longitude.innerText)},
        label: this.labels[this.labelIndex++ % this.labels.length],
      });
      this.bounds.extend(marker.getPosition())
      this.map.fitBounds(this.bounds)
    })
  }

  singleEvent() {
    let current_index = event.target.parentElement.dataset.index;
    let latitude = parseFloat(this.latitudeTargets[current_index].innerText)
    let longitude = parseFloat(this.longitudeTargets[current_index].innerText)
    this.map = new google.maps.Map(this.mapTarget, {
      center: {lat: latitude, lng: longitude },
      zoom: 18
    });
    new google.maps.Marker({
      map: this.map,
      position: {lat: latitude, lng: longitude },
    });
  }

}
