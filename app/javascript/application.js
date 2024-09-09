// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
// import "bootstrap-icons/font/bootstrap-icons.css"
// Add this line to import your CSS
// import "../assets/stylesheets/application.scss"

// Add these lines for Action Cable
import { createConsumer } from "@rails/actioncable"

// Create the Action Cable consumer
const consumer = createConsumer()

// Subscribe to the ChatChannel
consumer.subscriptions.create("ChatChannel", {
  connected() {
    console.log("Connected to ChatChannel")
  },

  disconnected() {
    console.log("Disconnected from ChatChannel")
  },

  received(data) {
    // Handle received messages
    const messagesContainer = document.querySelector("#messages")
    if (messagesContainer) {
      messagesContainer.insertAdjacentHTML('beforeend', data.message)
    }
  }
})
