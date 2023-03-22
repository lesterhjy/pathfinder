import { Controller } from "@hotwired/stimulus"
import Sortable from 'stimulus-sortable'

export default class extends Sortable {

  static targets = ["position"]

  connect() {
    super.connect()
    console.log(this.positionTargets)

    // The sortable.js instance.
    this.sortable

    // Your options
    this.options

    // Your default options
    this.defaultOptions
  }

  // You can override the `onUpdate` method here.
  onUpdate(event) {
    super.onUpdate(event)
    const e = new CustomEvent("order-updated")
    window.dispatchEvent(e)
  }

  // You can set default options in this getter for all sortable elements.
  get defaultOptions() {
    return {
      animation: 500,
    }
  }
}
