import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="panel-manager"
export default class extends Controller {
  static targets = ["panel", "button", "audioShort", "audioMiddle", "audioLong"]

  showShort(event) {
    // Gestion originale des panels
    this.panelTargets.forEach(panel => {
      panel.classList.add("d-none")
    });
    this.panelTargets[0].classList.remove("d-none")
    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.currentTarget.classList.add("active")

    // Gestion des lecteurs audio
    this.hideAllAudio()
    if (this.hasAudioShortTarget) {
      this.audioShortTarget.closest('.audio-player').classList.remove('d-none')
    }
  }

  showMiddle(event) {
    // Gestion originale des panels
    this.panelTargets.forEach(panel => {
      panel.classList.add("d-none")
    });
    this.panelTargets[1].classList.remove("d-none")
    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.currentTarget.classList.add("active")

    // Gestion des lecteurs audio
    this.hideAllAudio()
    if (this.hasAudioMiddleTarget) {
      this.audioMiddleTarget.closest('.audio-player').classList.remove('d-none')
    }
  }

  showLong(event) {
    // Gestion originale des panels
    this.panelTargets.forEach(panel => {
      panel.classList.add("d-none")
    });
    this.panelTargets[2].classList.remove("d-none")
    this.buttonTargets.forEach(button => {
      button.classList.remove("active")
    })
    event.currentTarget.classList.add("active")

    // Gestion des lecteurs audio
    this.hideAllAudio()
    if (this.hasAudioLongTarget) {
      this.audioLongTarget.closest('.audio-player').classList.remove('d-none')
    }
  }

  hideAllAudio() {
    // Masquer tous les lecteurs audio
    if (this.hasAudioShortTarget) {
      this.audioShortTarget.pause()
      this.audioShortTarget.closest('.audio-player').classList.add('d-none')
    }
    if (this.hasAudioMiddleTarget) {
      this.audioMiddleTarget.pause()
      this.audioMiddleTarget.closest('.audio-player').classList.add('d-none')
    }
    if (this.hasAudioLongTarget) {
      this.audioLongTarget.pause()
      this.audioLongTarget.closest('.audio-player').classList.add('d-none')
    }
  }
}
