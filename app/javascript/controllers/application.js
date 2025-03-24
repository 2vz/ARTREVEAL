import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };

document.addEventListener("turbo:load", () => {
  Turbo.setProgressBarDelay(999999); // désactive visuellement la barre
});
