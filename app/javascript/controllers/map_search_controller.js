import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  debugInput(event) {
    console.log("Input value:", event.target.value)
  }

  submit(event) {
    // Remove this line to allow form submission
    // event.preventDefault()
    console.log("Form submitted with query:", this.inputTarget.value)
  }
}
