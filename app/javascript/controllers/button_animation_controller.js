import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button-animation"
export default class extends Controller {
  static targets = ["button"]

  connect() {
    console.log("Button Animation Controller connected");
    console.log(this.buttonTarget);
  }

  changeStyle(e) {
    console.log("changeStyle")
    e.preventDefault();
    this.buttonTarget.classList.add("card-style");

    setTimeout(() => {
      this.buttonTarget.classList.add("no-transition");
      this.buttonTarget.classList.remove("card-style");
      setTimeout(() => {
        this.buttonTarget.classList.remove("no-transition");
      }, 20);
    }, 2000);
  }

  // buttonStyle() {
  //   var button = this.buttonTarget;
  //   button.classList.add("button-style");

  //   setTimeout(() => {
  //     button.classList.remove("button-style");
  //   }, 200); // 0.2 seconds
  // }

  // button.addEventListener("click", () => {
    //   button.setAttribute("disabled", true);

  //   setTimeout(() => {
    //     button.removeAttribute("disabled");
  //   }, 2000); // 2 seconds
  // });

  animateButton() {
    console.log("animateButton")
    this.buttonTarget.classList.add('animate');
    setTimeout(() => {
      this.buttonTarget.classList.remove('animate');
    }, 2000); // 2 seconds
  }
}
