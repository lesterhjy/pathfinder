import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="maps"
export default class extends Controller {
  static targets = ["map", "event", "longitude", "latitude", "address"];

  connect() {
    this.labels = "123456789";
    if (typeof(google) != "undefined") {
      this.initMap()
    }
  }

  initMap() {
    this.bounds = new google.maps.LatLngBounds();

    this.map = new google.maps.Map(this.mapTarget, {
      center: {lat: parseFloat(this.latitudeTarget.innerText), lng: parseFloat(this.longitudeTarget.innerText) },
      zoom: 12,
      mapId: 'ad11ac97853b71ad'
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

  updateMarkers() {
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
    let current_index = this.addressTargets.indexOf(event.target);
    let latitude = parseFloat(this.latitudeTargets[current_index].innerText)
    let longitude = parseFloat(this.longitudeTargets[current_index].innerText)
    this.map = new google.maps.Map(this.mapTarget, {
      center: {lat: latitude, lng: longitude },
      zoom: 18,
      mapId: 'ad11ac97853b71ad',
    });
    new google.maps.Marker({
      map: this.map,
      position: {lat: latitude, lng: longitude },
    });
  }

}
