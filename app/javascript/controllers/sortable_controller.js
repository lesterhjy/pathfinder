import { Controller } from "@hotwired/stimulus"
import Sortable from 'stimulus-sortable'

export default class extends Sortable {

  static targets = ["position", "form"]

  connect() {
    super.connect()
    // The sortable.js instance.
    this.sortable.options.group.name = "lists"
    this.sortable.options.onRemove = this.remove

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

  remove(event) {
    const newDate = event.to.dataset.date
    const url = event.item.dataset.sortableMoveUrl
    const oldPosition = event.item.dataset.position
    const newPosition = event.item.nextElementSibling.dataset.position
    console.log(oldPosition, newPosition)
    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.head.children["csrf-token"]["content"],
      },
      body: JSON.stringify({
        start_time: newDate,
        position: newPosition
      })
    }).then(response => {
      const e = new CustomEvent("order-updated")
      window.dispatchEvent(e)
    })
  }

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
