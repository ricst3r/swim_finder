import { Controller } from '@hotwired/stimulus'
export default class extends Controller {
  static targets = ['input', 'star']
  connect() {
    console.log('star-rating controller connected');
    this.updateStars()
  }
  updateStars() {
    const selectedRating = this.inputTargets.find(input => input.checked)?.value || 0
    this.updateStarDisplay(selectedRating)
  }
  highlight({ target }) {
    const rating = target.previousElementSibling.value
    this.updateStarDisplay(rating)
  }
  reset() {
    this.updateStars()
  }
  updateStarDisplay(rating) {
    // console.log('updateStarDisplay', rating);
    this.starTargets.forEach((star, index) => {
      const starValue = index + 1
      star.querySelector('i').classList.toggle('bi-star-fill', starValue <= rating)
      star.querySelector('i').classList.toggle('bi-star', starValue > rating)
    })
  }
}
