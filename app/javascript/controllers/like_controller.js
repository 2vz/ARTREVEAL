import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    liked: Boolean,
    workartId: Number,
    userWorkartId: Number,
  };

  toggleLike(event) {
    event.preventDefault();

    if (this.likedValue) {
      // Supprimer le like
      fetch(`/user_workarts/${this.userWorkartIdValue}`, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .content,
          Accept: "application/json",
        },
        credentials: "same-origin",
      }).then((response) => {
        if (response.ok) {
          this.likedValue = false;
          this.updateIcon(false);
        }
      });
    } else {
      // Créer le like
      fetch(`/workarts/${this.workartIdValue}/user_workarts`, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
            .content,
          Accept: "application/json",
        },
        credentials: "same-origin",
      })
        .then((response) => response.json())
        .then((data) => {
          this.likedValue = true;
          this.userWorkartIdValue = data.id;
          this.updateIcon(true);
        });
    }
  }

  updateIcon(liked) {
    const icon = this.element.querySelector("i");
    if (!icon) return;

    if (liked) {
      icon.classList.remove("fa-regular");
      icon.classList.add("fa-solid");
    } else {
      icon.classList.remove("fa-solid");
      icon.classList.add("fa-regular");
    }
  }
}
