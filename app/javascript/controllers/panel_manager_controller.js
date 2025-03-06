import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="panel-manager"
export default class extends Controller {
  static targets = ["panel","button"]

  showShort(event) {
    this.panelTargets.forEach(panel => {
      panel.classList.add("d-none")

    });
    this.panelTargets[0].classList.remove("d-none")
    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.currentTarget.classList.add("active")
  }

  showMiddle(event) {
    this.panelTargets.forEach(panel => {
      panel.classList.add("d-none")

    });
    this.panelTargets[1].classList.remove("d-none")
    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.currentTarget.classList.add("active")
  }

  showLong(event) {
    this.panelTargets.forEach(panel => {
      panel.classList.add("d-none")

    });
    this.panelTargets[2].classList.remove("d-none")
    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.currentTarget.classList.add("active")
  }
}
