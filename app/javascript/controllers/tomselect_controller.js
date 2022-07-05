import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static values = { options: Object }

  connect() {
    console.log("Hello Tom!")
    new TomSelect(
      this.element,
      this.optionsValue, {
        allowEmptyOption: true,
        plugins: ['no_active_items'],
	      persist: false,
	      create: true,
      })
  }
}
