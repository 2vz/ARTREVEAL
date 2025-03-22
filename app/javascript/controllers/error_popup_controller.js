import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="error-popup"
export default class extends Controller {
  static targets = ["errorPopup"];
  close() {
    const url = new URL(window.location);
    const overlayBlocker = document.querySelector(
      "[data-error-overlay-blocker]"
    );

    this.errorPopupTarget.classList.add("d-none");

    url.searchParams.delete("alert");
    window.history.replaceState({}, document.title, url);

    overlayBlocker.remove();
  }
}
