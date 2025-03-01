import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "form", "map"]

  connect() {
    console.log("Stimulus connecté !")
  }

  async create(event) {
    event.preventDefault();

    const form = this.formTarget;
    const response = await fetch(form.action, {
      method: "POST",
      body: new FormData(form),
      headers: { "Accept": "application/json" }
    });

    if (response.ok) {
      const flat = await response.json();
      this.listTarget.insertAdjacentHTML("beforeend", this.renderFlat(flat));
      form.reset();
    } else {
      const errorData = await response.json();
      this.displayErrors(errorData);
    }
  }

  displayErrors(errors) {
    let errorMessages = "<ul>";
    Object.values(errors).forEach(messages => {
      messages.forEach(msg => errorMessages += `<li>${msg}</li>`);
    });
    errorMessages += "</ul>";

    this.formTarget.insertAdjacentHTML("beforebegin", `<div class="error-messages">${errorMessages}</div>`);
  }


  renderFlat(flat) {
    return `<div class="flat">
      <h3>${flat.name}</h3>
      <p>${flat.address}</p>
    </div>`
  }
}
