import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    const label = event.currentTarget
    label.classList.toggle('btn-primary')
    label.classList.toggle('btn-success')
  }
}
