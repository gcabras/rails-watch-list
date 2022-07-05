import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "film" ]

  connect() {
    console.log("Hello Stimulus!")
  }

  show() {
    this.filmTarget.classList.toggle("d-none")
  }
}
