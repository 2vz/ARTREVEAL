import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "captureBtn",
    "canvas",
    "previewContainer",
    "previewImage",
    "closePreview",
    "sendPreview",
    "photoInput",
    "formSubmit",
  ];
  async capture() {
    const ctx = this.canvasTarget.getContext("2d");
    const liveVideo = document.querySelector("[data-live-video]");

    this.canvasTarget.width = liveVideo.videoWidth;
    this.canvasTarget.height = liveVideo.videoHeight;
    ctx.drawImage(
      liveVideo,
      0,
      0,
      this.canvasTarget.width,
      this.canvasTarget.height
    );

    this.previewImageTarget.src = this.canvasTarget.toDataURL("image/png");
    this.previewContainerTarget.classList.remove("d-none");
    this.photoInputTarget.value = this.canvasTarget.toDataURL("image/png");
  }

  async delete() {
    this.previewContainerTarget.classList.add("d-none");
  }

  async sendImage() {
    this.formSubmitTarget.click();
  }
}
