import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["panel", "button", "audioShort", "audioMiddle", "audioLong","audio", "playIcon", "pauseIcon", "progress", "progressContainer", "timeDisplay","short","middle","long"]

  connect() {
    if (!this.hasAudioTarget) return;

    if (this.audioTarget.readyState >= 1) {
      this.updateTimeDisplay();
    } else {
      this.audioTarget.addEventListener('loadedmetadata', () => this.updateTimeDisplay());
    }

    this.audioTarget.addEventListener('timeupdate', () => this.updateProgress());
    this.audioTarget.addEventListener('ended', () => this.handleEnded());
    this.progressContainerTarget.addEventListener('click', (e) => this.setProgress(e));
  }

  showShort(event) {
    console.log("short")
    this.shortTarget.classList.remove("d-none")
    this.middleTarget.classList.add("d-none")
    this.longTarget.classList.add("d-none")
    event.currentTarget.classList.add("active")
  }

  showMiddle(event) {
    console.log("middle")
    this.shortTarget.classList.add("d-none")
    this.middleTarget.classList.remove("d-none")
    this.longTarget.classList.add("d-none")
    event.currentTarget.classList.add("active")
  }

  showLong(event) {
    console.log("long")
    this.shortTarget.classList.add("d-none")
    this.middleTarget.classList.add("d-none")
    this.longTarget.classList.remove("d-none")
    event.currentTarget.classList.add("active")
  }

  hideAllAudio() {

    if (this.hasAudioShortTarget) {
      this.audioShortTarget.pause()
    }
    if (this.hasAudioMiddleTarget) {
      this.audioMiddleTarget.pause()
    }
    if (this.hasAudioLongTarget) {
      this.audioLongTarget.pause()
    }
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
      this.playIconTarget.style.display = 'none';
      this.pauseIconTarget.style.display = 'block';
  }

  playmiddle() {
      this.audioMiddleTarget.play()
      this.playIconTarget.style.display = 'none';
      this.pauseIconTarget.style.display = 'block';
  }

  playlong() {
      this.audioLongTarget.play()
      this.playIconTarget.style.display = 'none';
      this.pauseIconTarget.style.display = 'block';
  }

 pauseshort() {
  console.log("pause short")
      this.audioShortTarget.pause()
      this.playIconTarget.style.display = 'block';
      this.pauseIconTarget.style.display = 'none';
  }

  pausemiddle() {
    console.log("pause middle")
      this.audioMiddleTarget.pause()
      this.playIconTarget.style.display = 'block';
      this.pauseIconTarget.style.display = 'none';
  }

  pauselong() {
    console.log("pause long")
      this.audioLongTarget.pause()
      this.playIconTarget.style.display = 'block';
      this.pauseIconTarget.style.display = 'none';
  }

  handleEnded() {
    this.playIconTarget.style.display = 'block';
    this.pauseIconTarget.style.display = 'none';
    this.progressTarget.style.width = '0%';
    this.panelManagerTarget.currentTime = 0;
  }
}
