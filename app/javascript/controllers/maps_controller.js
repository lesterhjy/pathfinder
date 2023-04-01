import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="maps"
export default class extends Controller {
  static targets = ["map", "event", "longitude", "latitude", "address", "placeId"];

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
    let to_geocode
    if (this.placeIdTargets[current_index].innerText === "") {
      to_geocode = {address: this.addressTargets[current_index].innerText}
    } else {
      to_geocode = {placeId: this.placeIdTargets[current_index].innerText }
    }
    new google.maps.Geocoder()
    .geocode(to_geocode)
    .then(({ results }) => {
      if (results[0]) {
        this.map = new google.maps.Map(this.mapTarget, {
          center: results[0].geometry.location,
          zoom: 18,
          mapId: 'ad11ac97853b71ad',
        });
        const marker = new google.maps.Marker({
          map: this.map,
          position: results[0].geometry.location,
        });
        const infowindow = new google.maps.InfoWindow()
        infowindow.setContent(results[0].formatted_address);
        infowindow.open(this.map, marker);
      }
    })
  }


}
