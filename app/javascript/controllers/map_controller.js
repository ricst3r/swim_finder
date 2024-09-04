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
    this.map.addControl(new mapboxgl.FullscreenControl());

    //this.#addMarkersToMap()
    //this.#fitMapToMarkers()


    this.map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl }))
  }

  #addMarkersToMap() {
    this.spotsValue.forEach((spot) => {
      const popup = new mapboxgl.Popup().setHTML(spot.info_window)
      new mapboxgl.Marker()
        .setLngLat([ spot.lng, spot.lat ])
        .setPopup(popup)
        .addTo(this.map)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.spotsValue.forEach(spot => bounds.extend([ spot.lng, spot.lat ]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  updateMap(center, locations) {
    this.map.setCenter(center)
    this.map.setZoom(12) // Adjust zoom level as needed

    // Clear existing markers
    this.markers.forEach(marker => marker.remove())
    this.markers = []

    // Add new markers
    locations.forEach(location => {
      const marker = new mapboxgl.Marker()
        .setLngLat([location.lng, location.lat])
        .addTo(this.map)
      this.markers.push(marker)
    })
  }
}
