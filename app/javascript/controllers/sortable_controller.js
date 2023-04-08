import { Controller } from "@hotwired/stimulus"
import Sortable from 'stimulus-sortable'

export default class extends Sortable {

  static targets = ["position", "form"]

  connect() {
    super.connect()
    // The sortable.js instance.
    this.sortable.options.group.name = "lists"
    this.sortable.options.onRemove = this.remove
    this.sortable.options.ghostClass = "ghost"
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

  remove(event) {
    console.log(event.to.dataset)
    let newDate
    if (event.to.dataset.date) {
      newDate = event.to.dataset.date
    } else {
      newDate = null
    }
    console.log(newDate)

    const url = event.item.dataset.sortableMoveUrl
    const oldPosition = parseInt(event.item.dataset.position, 10)
    let newPosition


    if (event.item.nextElementSibling) { // there is something under the item that was moved, so take ref from that
      newPosition = parseInt(event.item.nextElementSibling.dataset.position, 10)
      console.log(newPosition)
    } else if (event.item.previousElementSibling) { // there is nothing under the item that was moved, so take ref from the item above
      newPosition = parseInt(event.item.previousElementSibling.dataset.position, 10) + 1
    }

    if (newPosition > oldPosition) {
      newPosition -= 1;
    }

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
