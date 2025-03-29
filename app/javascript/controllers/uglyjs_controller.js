import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="uglyjs"
export default class extends Controller {
  static targets = ["panel", "modal", "emailModal", "emailForm"];
  connect() {
    document.addEventListener("DOMContentLoaded", () => {
      const audioPlayers = document.querySelectorAll("audio");
      const closeBtn = document.querySelector(".close");
      const emailForm = document.querySelector("#emailModal form");

      // let isDragging = false;
      // let startY;

      // Fermeture modale
      closeBtn.addEventListener("click", () => {
        this.modalTarget.style.display = "none";
      });
      window.addEventListener("click", (event) => {
        if (event.target === modal) {
          this.modalTarget.style.display = "none";
        }
      });

      // --- Nouvelle gestion du swipe sur #panelHandle avec basculement du titre --- //
      // const panelHandle = document.getElementById("panelHandle");
      // let startYHandle = null;

      // panelHandle.addEventListener("touchstart", (e) => {
      //   startYHandle = e.touches[0].clientY;
      // });

      // panelHandle.addEventListener("touchend", (e) => {
      //   if (startYHandle === null) return;
      //   const endYHandle = e.changedTouches[0].clientY;
      //   const deltaYHandle = startYHandle - endYHandle;
      //   if (deltaYHandle > 50) {
      //     // Swipe vers le haut : ouvrir le panel
      //     this.panelTarget.classList.add("active");
      //     document.body.style.overflow = "hidden";
      //     // Bascule : cache le titre dans le handle et affiche celui dans le contenu
      //     document.querySelector(".panel-title-handle").classList.add("d-none");
      //     document
      //       .querySelector(".panel-title-content")
      //       .classList.remove("d-none");
      //   } else if (deltaYHandle < -50) {
      //     // Swipe vers le bas : fermer le panel
      //     this.panelTarget.classList.remove("active");
      //     document.body.style.overflow = "";
      //     // Bascule : affiche le titre dans le handle et cache celui dans le contenu
      //     document
      //       .querySelector(".panel-title-handle")
      //       .classList.remove("d-none");
      //     document
      //       .querySelector(".panel-title-content")
      //       .classList.add("d-none");
      //   }
      //   startYHandle = null;
      // });

      panelHandle.addEventListener("click", (e) => {
        // Toggle l'overlay au clic et bascule la visibilité du titre
        if (this.panelTarget.classList.contains("active")) {
          this.panelTarget.classList.remove("active");
          document.body.style.overflow = "";
          document
            .querySelector(".panel-title-handle")
            .classList.remove("d-none");
          document
            .querySelector(".panel-title-content")
            .classList.add("d-none");
        } else {
          this.panelTarget.classList.add("active");
          document.body.style.overflow = "hidden";
          document.querySelector(".panel-title-handle").classList.add("d-none");
          document
            .querySelector(".panel-title-content")
            .classList.remove("d-none");
        }
      });

      audioPlayers.forEach((audio) => {
        audio.addEventListener("click", (e) => {
          e.stopPropagation();
        });
      });
    });
  }

  togglePanel(e) {
    console.log("prout");
    e.stopPropagation();
    this.panelTarget.classList.toggle("active");
  }

  toggleEmailModal() {
    this.emailModalTarget.classList.toggle("d-none");
    this.emailModalTarget.classList.toggle("d-block");
  }

  submitEmailForm(event) {
    event.preventDefault();

    const form = event.currentTarget;
    const formData = new FormData(form);
    const url = form.action;

    const options = {
      method: "POST",
      body: formData,
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
    };

    fetch(url, options)
      .then((response) => response.json())
      .then((data) => {
        this.showConfirmationMessage(data.message);
      });
  }

  showConfirmationMessage(message) {
    const formContent = this.emailFormTarget;
    const confirmationDiv = document.createElement("div");
    confirmationDiv.className = "email-confirmation";

    confirmationDiv.className = "email-confirmation";
    confirmationDiv.innerHTML = `
        <div class="confirmation-icon">✓</div>
        <h4>Email ready to go !</h4>
        <p>${message}</p>
        <button id="back-to-workart" class="btn-back" data-action="click->uglyjs#toggleEmailModal">Go back</button>
    `;

    formContent.innerHTML = "";
    formContent.appendChild(confirmationDiv);

    document
      .getElementById("back-to-workart")
      .addEventListener("click", function () {
        this.modalTarget.style.display = "none";

        setTimeout(() => {
          location.reload();
        }, 100);
      });
  }
}
