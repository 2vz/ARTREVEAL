import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "audioShort",
    "short",
    "shortContainer",
    "middleContainer",
    "longContainer",
    "audioMiddle",
    "middle",
    "audioLong",
    "long",
    "playIcon",
    "pauseIcon",
    "progress",
    "progressContainer",
    "timeDisplay",
  ];

  connect() {}

  showShort(event) {
    this.shortTarget.classList.remove("d-none");
    this.middleTarget.classList.add("d-none");
    this.longTarget.classList.add("d-none");
    this.shortContainerTarget.classList.remove("d-none");
    this.middleContainerTarget.classList.add("d-none");
    this.longContainerTarget.classList.add("d-none");
    event.currentTarget.classList.add("active");
  }

  showMiddle(event) {
    this.shortTarget.classList.add("d-none");
    this.middleTarget.classList.remove("d-none");
    this.longTarget.classList.add("d-none");
    this.shortContainerTarget.classList.add("d-none");
    this.middleContainerTarget.classList.remove("d-none");
    this.shortContainerTarget.classList.add("d-none");
    this.longContainerTarget.classList.add("d-none");
    event.currentTarget.classList.add("active");
  }

  showLong(event) {
    this.shortTarget.classList.add("d-none");
    this.middleTarget.classList.add("d-none");
    this.longTarget.classList.remove("d-none");
    this.shortContainerTarget.classList.add("d-none");
    this.longContainerTarget.classList.remove("d-none");
    this.shortContainerTarget.classList.add("d-none");
    this.middleContainerTarget.classList.add("d-none");
    event.currentTarget.classList.add("active");
  }

  playshort() {
    this.audioShortTarget.play();
    this.playDisplay();
  }

  playmiddle() {
    this.audioMiddleTarget.play();
    this.playDisplay();
  }

  playlong() {
    this.audioLongTarget.play();
    this.playDisplay();
  }

  playDisplay() {
    this.playIconTargets.forEach((icon) => (icon.style.display = "none"));
    this.pauseIconTargets.forEach((icon) => (icon.style.display = "block"));
  }

  pauseDisplay() {
    this.playIconTargets.forEach((icon) => (icon.style.display = "block"));
    this.pauseIconTargets.forEach((icon) => (icon.style.display = "none"));
  }

  pauseshort() {
    this.audioShortTarget.pause();
    this.pauseDisplay();
  }

  pausemiddle() {
    this.audioMiddleTarget.pause();
    this.pauseDisplay();
  }

  pauselong() {
    this.audioLongTarget.pause();
    this.pauseDisplay();
  }
}
