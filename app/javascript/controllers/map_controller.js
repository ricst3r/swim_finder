// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static values = {
    apiKey: String,
    spots: Array,
    center: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    // Create a custom geocoder
    const customGeocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      localGeocoder: this.#forwardGeocoder.bind(this),
      zoom: 12,
      placeholder: "     Looking for swim spots...",
      marker: false
    })

    this.map.addControl(customGeocoder)

    // Add a Turbo Stream listener
    document.addEventListener("turbo:load", () => {
      this.#initializeMap();
    });

    // Listener for new locations
    document.addEventListener("turbo:frame-load", (event) => {
      if (event.target.id === "locations") {
        this.addNewMarkers();
      }
    });
  }

  addNewMarkers() {
    const newLocations = document.querySelectorAll('.location[data-marker="false"]');
    newLocations.forEach((location) => {
      const lat = location.dataset.lat;
      const lng = location.dataset.lng;
      if (lat && lng) {
        const marker = new mapboxgl.Marker()
          .setLngLat([lng, lat])
          .addTo(this.map);
        location.dataset.marker = "true";
      }
    });
  }

  #addMarkersToMap() {
    this.spotsValue.forEach((spot) => {
      const popup = new mapboxgl.Popup().setHTML(spot.info_window)

      // Create a DOM element for each marker
      const el = document.createElement('div');
      el.className = 'marker';
      el.style.backgroundImage = "url('/assets/logo_round.png')";
      el.style.width = '30px';  // Adjust size as needed
      el.style.height = '30px'; // Adjust size as needed
      el.style.backgroundSize = 'contain';
      el.style.backgroundRepeat = 'no-repeat';
      el.style.backgroundPosition = 'center';

      // Create and add the custom marker to the map
      new mapboxgl.Marker(el)
        .setLngLat([spot.lng, spot.lat])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.spotsValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 12, duration: 0 })
  }

  #forwardGeocoder(query) {
    if (!query) return [];
    const features = this.spotsValue
      .filter(spot =>
        (spot.name && spot.name.toLowerCase().includes(query.toLowerCase())) ||
        (spot.info_window && spot.info_window.toLowerCase().includes(query.toLowerCase()))
      )
      .map(spot => ({
        center: [spot.lng, spot.lat],
        geometry: {
          type: 'Point',
          coordinates: [spot.lng, spot.lat]
        },
        place_name: spot.name || `SwimFind Spot found`,
        place_type: ['place'],
        bbox: [spot.lng, spot.lat, spot.lng, spot.lat]
      }));

    return features;
  }

  #initializeMap() {
    // Add any initialization logic here
    this.#addMarkersToMap();
    this.#fitMapToMarkers();
  }

}
