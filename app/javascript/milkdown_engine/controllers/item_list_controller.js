import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]
  static values = { selectedId: { type: Number, default: 0 } }

  connect() {
    this.#applySelected()
  }

  select(event) {
    const card = event.currentTarget.querySelector("[data-note-id]")
      || event.target.closest("[data-note-id]")
    if (card) {
      this.selectedIdValue = parseInt(card.dataset.noteId, 10) || 0
    }
  }

  selectedIdValueChanged() {
    this.#applySelected()
  }

  #applySelected() {
    this.itemTargets.forEach((item) => {
      const id = parseInt(item.dataset.noteId, 10) || 0
      item.classList.toggle("active", id === this.selectedIdValue)
    })
  }
}
