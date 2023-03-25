import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

// Connects to data-controller="typed-js"
export default class extends Controller {
  connect() {
    console.log('typed-js connected')
    new Typed(this.element, {
      strings: ["Welcome, adventurer.",
                "Welcome, explorer.",
                "Welcome, pathfinder."],
      smartBackspace: true,
      backSpeed: 20,
      typeSpeed: 70,
      showCursor: false,
      loop: false
    })
  }
}
