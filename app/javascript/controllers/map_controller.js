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


    this.map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl }))

  //   this.map.on('click', 'locations', (e) => {
  //     const locationId = e.features[0].properties.id;

  //     fetch(`/locations/${locationId}`)
  //       .then(response => response.json())
  //       .then(location => {
  //         // Create and show a popup with the location details
  //         new mapboxgl.Popup()
  //           .setLngLat([location.longitude, location.latitude])
  //           .setHTML(`
  //             <h3>${location.name}</h3>
  //             <p>${location.description}</p>
  //           `)
  //           .addTo(this.map);
  //       })
  //       .catch(error => console.error('Error:', error));
  //   });
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

}
