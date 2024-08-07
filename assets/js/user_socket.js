// Import the necessary Phoenix socket library
import { Socket } from "phoenix"

// Connect to the socket without any authentication parameters
let socket = new Socket("/socket")

// Open the connection
socket.connect()

// Define the channel, specifying the topic. Adjust the topic as necessary.
// let channel = socket.channel("superheroes:lobby", {})

// // Join the channel
// channel.join()
//   .receive("ok", resp => { console.log("Joined successfully", resp) })
//   .receive("error", resp => { console.log("Unable to join", resp) })

// // Example of handling a custom event
// channel.on("superheroes_list", payload => {
//   console.log("Received superheroes list:", payload.superheroes)
//   // Additional code to handle the superheroes list, e.g., update the DOM
// })

// Export the socket if it needs to be used elsewhere in your JavaScript
export default socket
