import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    likedWorkarts: Array,
  };

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    if (!this.map) {
      this.map = new mapboxgl.Map({
        container: this.element,
        style: "mapbox://styles/mapbox/streets-v12",
        logoControl: false,
        attributionControl: false,
      });
    }

    const markers = this.markersValue;
    this.#addMarkersToMap(markers);
    this.#fitMapToMarkers(markers);
    this.#checkForWorkartId(markers);

    window.addEventListener("workartIdChanged", () => {
      this.#checkForWorkartId(markers);
    });

    // Ajoute un écouteur global pour fermer la popup quand on clique en dehors
    document.addEventListener("click", this.#closePopupOutside);
  }

  #addMarkersToMap(markers) {
    if (!this.map || !markers || markers.length === 0) return;

    markers.forEach((marker, index) => {
      if (!marker.lng || !marker.lat) return;

      const el = document.createElement("div");
      el.className = "custom-marker";
      el.innerHTML = `
        <div class="icons">
          <i class="fas fa-map-marker-alt" style="color: red;"></i>
        </div>
        <div class="like-button">
          <svg class="like-heart" xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24">
            <path fill="white" stroke="pink" stroke-width="2" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
          </svg>
        </div>
      `;

      const markerElement = new mapboxgl.Marker(el)
        .setLngLat([marker.lng, marker.lat])
        .addTo(this.map);

      markerElement.getElement().addEventListener("click", (event) => {
        event.stopPropagation();
        this.#showPopup(marker, index, markers);
      });
    });
  }

  #showPopup(marker, index, markers) {
    const popupContainer = document.getElementById("map-popup-container");
    popupContainer.innerHTML = `
      <div class="popup-navigation">
        <button id="prev-workart" class="nav-button"><</button>
        <div class="popup-content">
          <div class="mapbox-image-container">
            ${
              marker.imageUrl
                ? `<img src="${marker.imageUrl}" class="popup-image" data-workart-id="${marker.idworkart}" />`
                : ""
            }
          </div>
          <div class="mapbox-text-container">
            <h3>${marker.title}</h3>
            <p>${marker.address}</p>
          </div>
        </div>
        <button id="next-workart" class="nav-button">></button>
      </div>
    `;

    popupContainer.style.display = "block";

    document
      .getElementById("prev-workart")
      .addEventListener("click", (event) => {
        event.stopPropagation();
        this.#navigateWorkart(index - 1, markers);
      });

    document
      .getElementById("next-workart")
      .addEventListener("click", (event) => {
        event.stopPropagation();
        this.#navigateWorkart(index + 1, markers);
      });

    // Ajout du clic sur l’image pour rediriger vers la page de l’œuvre
    const imageElement = popupContainer.querySelector(".popup-image");
    if (imageElement) {
      imageElement.addEventListener("click", (event) => {
        event.stopPropagation();
        const workartId = event.target.getAttribute("data-workart-id");
        if (workartId) {
          window.location.href = `/workarts/${workartId}`;
        }
      });
    }

    this.#zoomOnWorkart(marker);
  }

  #navigateWorkart(newIndex, markers) {
    if (newIndex < 0) newIndex = markers.length - 1;
    if (newIndex >= markers.length) newIndex = 0;
    this.#showPopup(markers[newIndex], newIndex, markers);
  }

  #closePopupOutside = (event) => {
    const popupContainer = document.getElementById("map-popup-container");
    if (popupContainer && !popupContainer.contains(event.target)) {
      popupContainer.style.display = "none";
    }
  };

  #fitMapToMarkers(markers) {
    if (!this.map || !markers || markers.length === 0) return;
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach((marker) => {
      if (marker.lng && marker.lat) {
        bounds.extend([marker.lng, marker.lat]);
      }
    });
    if (!bounds.isEmpty()) {
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
    }
  }

  #checkForWorkartId(markers) {
    const urlParams = new URLSearchParams(window.location.search);
    const workartId = urlParams.get("workart_id");
    if (workartId) {
      const marker = markers.find((m) => m.idworkart == workartId);
      if (marker) {
        this.#zoomOnWorkart(marker);
      }
    }
  }

  #zoomOnWorkart(marker) {
    if (!marker || !this.map) return;

    this.map.flyTo({
      center: [marker.lng, marker.lat],
      zoom: 15,
      speed: 1.2,
      curve: 1,
      easing(t) {
        return t;
      },
    });
  }
}
