import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.cards = Array.from(this.element.querySelectorAll(".carousel-card"));
    this.element.addEventListener("scroll", this.handleScroll.bind(this), {
      passive: true,
    });
    this.debounceTimer = null;

    window.addEventListener("workartIdChangedFromMap", (event) => {
      const workartId = event.detail.idworkart;

      const targetCard = this.element.querySelector(
        `.carousel-card[data-idworkart="${workartId}"]`
      );

      if (targetCard) {
        targetCard.scrollIntoView({ behavior: "smooth", inline: "center" });
      }
    });
  }

  handleScroll() {
    clearTimeout(this.debounceTimer);
    this.debounceTimer = setTimeout(() => {
      const containerCenter =
        this.element.scrollLeft + this.element.offsetWidth / 2;

      let closestCard = null;
      let closestDistance = Infinity;

      this.cards.forEach((card) => {
        const cardCenter = card.offsetLeft + card.offsetWidth / 2;
        const distance = Math.abs(containerCenter - cardCenter);
        if (distance < closestDistance) {
          closestDistance = distance;
          closestCard = card;
        }
      });

      if (closestCard) {
        const lat = closestCard.dataset.lat;
        const lng = closestCard.dataset.lng;

        const event = new CustomEvent("carouselWorkartChanged", {
          detail: { lat: parseFloat(lat), lng: parseFloat(lng) },
        });

        window.dispatchEvent(event);
      }
    }, 100);
  }
}
