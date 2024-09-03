import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  debugInput(event) {
    console.log("Input value:", event.target.value)
  }

  submit(event) {
    event.preventDefault()
    console.log("Form submitted with query:", this.inputTarget.value)
    // Implement the search functionality here
    // You might want to make an AJAX request to your backend
    // and update the map with the results
  }
}
