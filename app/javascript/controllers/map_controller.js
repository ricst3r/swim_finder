// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl' // Don't forget this!

export default class extends Controller {
  static values = {
    apiKey: String,
    spots: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })
    this.#addSpotsToMap()
    this.#fitMapToSpots()
  }

  #addSpotsToMap() {
    this.spotsValue.forEach((spot) => {
      new mapboxgl.Spot()
        .setLngLat([ spot.lng, spot.lat ])
        .addTo(this.map)
    })
  }

  #fitMapToSpots() {
    const bounds = new mapboxgl.LngLatBounds()
    this.spotsValue.forEach(spot => bounds.extend([ spot.lng, spot.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
