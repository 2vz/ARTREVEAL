import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="camera-stream"
export default class extends Controller {
  static targets = ["liveVideo", "errorPage"];

  connect() {
    this.startCamera();
  }

  async startCamera() {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: "environment" },
      });

      this.liveVideoTarget.srcObject = stream;
      this.errorPageTarget.classList.add("d-none");

      stream.getTracks().forEach((track) => {
        track.addEventListener("ended", () => this.showError());
        track.addEventListener("inactive", () => this.showError());
      });
    } catch {
      this.showError();
    }
  }

  showError() {
    this.errorPageTarget.classList.remove("d-none");
  }

  retry() {
    window.location.reload();
  }
}
