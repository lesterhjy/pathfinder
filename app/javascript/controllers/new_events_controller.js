import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-events"
export default class extends Controller {
  static targets = ["address"]
  static values = { apiKey: String }

  connect() {

  }
}
