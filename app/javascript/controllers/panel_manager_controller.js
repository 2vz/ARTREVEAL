import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button", "audioShort", "audioMiddle", "audioLong", "audio", "playIcon", "pauseIcon", "progress", "progressContainer", "timeDisplay", "short", "middle", "long"]

  connect() {
    console.log('shortTarget', this.panelTarget)
    if (!this.hasAudioTarget) return;

    if (this.audioTarget.readyState >= 1) {
      this.updateTimeDisplay();
    } else {
      this.audioTarget.addEventListener('loadedmetadata', () => this.updateTimeDisplay());
    }


    this.audioTarget.addEventListener('progress', () => this.updateProgress());
    this.audioTarget.addEventListener('ended', () => this.handleEnded());
    this.progressContainerTarget.addEventListener('click', (e) => this.setProgress(e));
  }

  showShort(event) {
    this.shortTarget.classList.remove("d-none")
    this.middleTarget.classList.add("d-none")
    this.longTarget.classList.add("d-none")
    event.currentTarget.classList.add("active")
  }

  showMiddle(event) {
    this.shortTarget.classList.add("d-none")
    this.middleTarget.classList.remove("d-none")
    this.longTarget.classList.add("d-none")
    event.currentTarget.classList.add("active")
  }

  showLong(event) {
    this.shortTarget.classList.add("d-none")
    this.middleTarget.classList.add("d-none")
    this.longTarget.classList.remove("d-none")
    event.currentTarget.classList.add("active")
  }

  updateTimeDisplay() {
    this.timeDisplayTarget.textContent = `0:00 / ${this.formatTime(this.audioTarget.duration)}`;
  }

  formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = Math.floor(seconds % 60);
    return `${minutes}:${remainingSeconds < 10 ? '0' : ''}${remainingSeconds}`;
  }

  updateProgress() {
    const progress = (this.audioTarget.currentTime / this.audioTarget.duration) * 100;
    this.progressTarget.style.width = `${progress}%`;

    this.timeDisplayTarget.textContent = `${this.formatTime(this.audioTarget.currentTime)} / ${this.formatTime(this.audioTarget.duration || 0)}`;
  }

  setProgress(e) {
    const width = this.progressContainerTarget.clientWidth;
    const clickX = e.offsetX;
    const duration = this.audioTarget.duration;

    this.audioTarget.currentTime = (clickX / width) * duration;
  }

  playshort() {
    this.audioShortTarget.play()
    this.playDisplay()
  }

  playmiddle() {
    this.audioMiddleTarget.play()
    this.playDisplay()
  }

  playlong() {
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

  handleEnded() {
    this.playIconTarget.style.display = 'block';
    this.pauseIconTarget.style.display = 'none';
    this.progressTarget.style.width = '0%';
    this.panelManagerTarget.currentTime = 0;
  }
}
