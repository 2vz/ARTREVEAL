import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audioShort", "short", "shortContainer","middleContainer","longContainer", "audioMiddle", "middle", "audioLong", "long", "playIcon", "pauseIcon", "progress", "progressContainer", "timeDisplay"]

  connect() {
    console.log(this.audioShortTarget, this.audioMiddleTarget, this.audioLongTarget)
    // if (this.audioTarget.readyState >= 1) {
    //   this.updateTimeDisplay();
    // } else {
    //   this.audioTarget.addEventListener('loadedmetadata', () => this.updateTimeDisplay());
    // }

    // this.audioTarget.addEventListener('progress', () => this.updateProgress());
    // this.audioTarget.addEventListener('ended', () => this.handleEnded());
    // this.progressContainerTarget.addEventListener('click', (e) => this.setProgress(e));
  }

  showShort(event) {
    this.shortTarget.classList.remove("d-none")
    this.middleTarget.classList.add("d-none")
    this.longTarget.classList.add("d-none")
    this.shortContainerTarget.classList.remove("d-none")
    this.middleContainerTarget.classList.add("d-none")
    this.longContainerTarget.classList.add("d-none")
    event.currentTarget.classList.add("active")
  }

  showMiddle(event) {
    this.shortTarget.classList.add("d-none")
    this.middleTarget.classList.remove("d-none")
    this.longTarget.classList.add("d-none")
    this.shortContainerTarget.classList.add("d-none")
    this.middleContainerTarget.classList.remove("d-none")
    this.shortContainerTarget.classList.add("d-none")
    this.longContainerTarget.classList.add("d-none")
    event.currentTarget.classList.add("active")
  }

  showLong(event) {
    this.shortTarget.classList.add("d-none")
    this.middleTarget.classList.add("d-none")
    this.longTarget.classList.remove("d-none")
    this.shortContainerTarget.classList.add("d-none")
    this.longContainerTarget.classList.remove("d-none")
    this.shortContainerTarget.classList.add("d-none")
    this.middleContainerTarget.classList.add("d-none")
    event.currentTarget.classList.add("active")
  }

  playshort() {
    console.log('short', this.audioShortTarget)
    this.audioShortTarget.play()
    this.playDisplay()
  }

  playmiddle() {
    console.log('middle', this.audioMiddleTarget)
    this.audioMiddleTarget.play()
    this.playDisplay()
  }

  playlong() {
    console.log('long', this.audioLongTarget)
    this.audioLongTarget.play()
    this.playDisplay()
  }

  playDisplay() {
    this.playIconTargets.forEach(icon => icon.style.display = 'none')
    this.pauseIconTargets.forEach(icon => icon.style.display = 'block')
  }

  pauseDisplay() {
    this.playIconTargets.forEach(icon => icon.style.display = 'block')
    this.pauseIconTargets.forEach(icon => icon.style.display = 'none')
  }

  pauseshort() {
    this.audioShortTarget.pause()
    this.pauseDisplay()
  }

  pausemiddle() {
    this.audioMiddleTarget.pause()
    this.pauseDisplay()

  }

  pauselong() {
    this.audioLongTarget.pause()
    this.pauseDisplay()
  }

}
