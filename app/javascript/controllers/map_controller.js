import { Controller } from "@hotwired/stimulus";
import mapboxgl from "mapbox-gl";

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array, // L'array de données des markers
  };

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;

    if (!this.map) {
      this.map = new mapboxgl.Map({
        container: this.element,
        style: "mapbox://styles/mapbox/streets-v12",
      });
    }

    this.#addMarkersToMap();
    this.#fitMapToMarkers();
  }

  #addMarkersToMap() {
    if (!this.map || !this.markersValue || this.markersValue.length === 0)
      return;

    this.markersValue.forEach((marker) => {
      if (!marker.lng || !marker.lat) return;
      console.log(this.markersValue); // Affiche la totalité des données des markers

      // Création du contenu du popup avec l'image si elle est présente
      const popupContent = `
        <div class="popup-content">
    ${
      marker.imageUrl
        ? `<img src="${marker.imageUrl}" alt="${marker.name}" class="popup-image" />`
        : ""
    }
    <div>
      <h3>${marker.name}</h3>
      <p>${marker.address}</p>
    </div>
  </div>
`;
      const popup = new mapboxgl.Popup().setHTML(popupContent);

      const el = document.createElement("div");
      el.className = "custom-marker";
      el.innerHTML = `
        <div class="icons">
          <i class="fas fa-map-marker-alt" style="color: red;"></i> <!-- Icône de localisation -->
        </div>
        <div class="like-button">
          <svg id="like-heart" xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24">
            <path id="heart-path" fill="white" stroke="pink" stroke-width="2" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
          </svg>
        </div>
      `;

      new mapboxgl.Marker(el)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map);
    });
  }

  #fitMapToMarkers() {
    if (!this.map || !this.markersValue || this.markersValue.length === 0)
      return;

    const bounds = new mapboxgl.LngLatBounds();

    this.markersValue.forEach((marker) => {
      if (marker.lng && marker.lat) {
        bounds.extend([marker.lng, marker.lat]);
      }
    });

    if (!bounds.isEmpty()) {
      this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
    }
  }
}
