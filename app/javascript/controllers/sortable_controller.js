import { Controller } from "@hotwired/stimulus"
import Sortable from 'stimulus-sortable'

export default class extends Sortable {

  static targets = ["position"]

  connect() {
    super.connect()
    // The sortable.js instance.
    this.sortable.options.group.name = "lists"
    console.log(this.sortable)

    // Your options
    this.options

    // Your default options
    this.defaultOptions
  }

  updatePositions() {
    console.log("updatePositions")
    this.positionTargets.forEach((positionTarget, index) => {
      let newIndex = this.positionTargets.indexOf(positionTarget)
      positionTarget.innerHTML = `<h3>${newIndex + 1}</h3>`;
    })
  }

  // You can override the `onUpdate` method here.

  onMove(event) {
    super.onMove(event)
    console.log("onMove")
  }

  onStart(event) {
    super.onStart(event)
    console.log("onStart")
  }

  onUpdate(event) {
    console.log("onUpdate")
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
