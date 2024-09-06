import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelector("#explore-button").addEventListener("click", () => {
      this.element.style.display = "none";
    });
  }
}
