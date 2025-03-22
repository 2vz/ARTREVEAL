import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="ai-error-popup"
export default class extends Controller {
  static targets = ["popup", "overlay"];

  connect() {
    const url = new URL(window.location);
    if (url.searchParams.has("ai_error")) {
      this.popupTarget.classList.remove("d-none");
      this.overlayTarget.classList.remove("d-none");
      url.searchParams.delete("ai_error");
      window.history.replaceState({}, document.title, url);
    }
  }

  close() {
    this.popupTarget.classList.add("d-none");
    this.overlayTarget.classList.add("d-none");
  }
}
