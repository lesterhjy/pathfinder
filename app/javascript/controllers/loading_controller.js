import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

// Connects to data-controller="loading"
export default class extends Controller {
  connect() {
    console.log('loading controller connected')
    new Typed(this.element, {
      strings: ["Gathering all the information to put together a great itinerary.",
                "Looking at all the back alleys, high streets and less trodden paths.",
                "Mapping all the places that this city has to offer.",
                "Putting together a list of familiar and unexpected places."],
      smartBackspace: true,
      backSpeed: 30,
      typeSpeed: 70,
      showCursor: false,
      loop: true
    })
  }
}
