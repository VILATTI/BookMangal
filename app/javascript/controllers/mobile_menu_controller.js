import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "openIcon", "closeIcon"]

  toggle() {
    const isHidden = this.menuTarget.classList.contains("hidden")
    this.menuTarget.classList.toggle("hidden", !isHidden)
    if (this.hasOpenIconTarget)  this.openIconTarget.classList.toggle("hidden", !isHidden)
    if (this.hasCloseIconTarget) this.closeIconTarget.classList.toggle("hidden", isHidden)
  }

  // Закрити при кліку поза меню
  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      if (this.hasOpenIconTarget)  this.openIconTarget.classList.remove("hidden")
      if (this.hasCloseIconTarget) this.closeIconTarget.classList.add("hidden")
    }
  }

  connect() {
    this._outsideClickHandler = this.hide.bind(this)
    document.addEventListener("click", this._outsideClickHandler)
  }

  disconnect() {
    document.removeEventListener("click", this._outsideClickHandler)
  }
}
