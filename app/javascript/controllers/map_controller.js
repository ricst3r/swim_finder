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

    // Add fullscreen control
    // this.map.addControl(new mapboxgl.FullscreenControl());

    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    // Erstellen Sie einen benutzerdefinierten Geocoder
    const customGeocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      localGeocoder: this.#forwardGeocoder.bind(this),
      zoom: 14,
      placeholder: "Looking for swim spots...",
      marker: false
    })

    this.map.addControl(customGeocoder)
  }

  #addMarkersToMap() {
    console.log(this.spotsValue)
    this.spotsValue.forEach((spot) => {
      const popup = new mapboxgl.Popup().setHTML(spot.info_window)

      // Attach popup to the marker directly
      new mapboxgl.Marker()
        .setLngLat([spot.lng, spot.lat])
        .setPopup(popup) // Links the popup to the marker
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    console.log(this.spotsValue)
    this.spotsValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  #forwardGeocoder(query) {
    if (!query) return [];
    console.log(this.spotsValue)
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

}
