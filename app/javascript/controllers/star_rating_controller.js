import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "star", "icon"]

  connect() {
    this.updateStars()
  }

  highlight(event) {
    const rating = parseInt(event.currentTarget.getAttribute("for").replace("review_rating", ""))
    this.iconTargets.forEach((icon, index) => {
      icon.classList.toggle("bi-star-fill", index < rating)
      icon.classList.toggle("bi-star", index >= rating)
    })
  }

  reset() {
    this.updateStars()
  }

  setRating(event) {
    const rating = parseInt(event.currentTarget.getAttribute("for").replace("review_rating", ""))
    this.inputTargets.find(input => input.value == rating).checked = true
    this.updateStars()
  }

  updateStars() {
    const checkedInput = this.inputTargets.find(input => input.checked)
    const rating = checkedInput ? parseInt(checkedInput.value) : 0
    this.iconTargets.forEach((icon, index) => {
      icon.classList.toggle("bi-star-fill", index < rating)
      icon.classList.toggle("bi-star", index >= rating)
    })
  }
}
