import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const heartPath = document.getElementById('heart-path');

    // Vérifie si le cœur est rempli ou non
    if (heartPath.getAttribute('fill') === 'none') {
      heartPath.setAttribute('fill', 'white'); // Remplir le cœur en blanc
      heartPath.setAttribute('stroke', 'pink'); // Change le tracé en rose
    } else {
      heartPath.setAttribute('fill', 'none'); // Retirer le remplissage du cœur
      heartPath.setAttribute('stroke', 'white'); // Tracé blanc
    }
  }
}
