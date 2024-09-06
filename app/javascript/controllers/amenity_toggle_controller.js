import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    const checkbox = event.target.previousElementSibling
    checkbox.checked = !checkbox.checked
    event.target.classList.toggle('active')
  }
}
