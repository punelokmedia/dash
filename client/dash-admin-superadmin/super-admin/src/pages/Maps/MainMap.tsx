import { useEffect, useState } from "react"
import { MapContainer, Marker, Popup, TileLayer } from "react-leaflet"
import L from "leaflet"
import "leaflet/dist/leaflet.css"
import axios from "axios"

type Location = {
  lat: number
  lng: number
  type: "rider" | "warehouse"
}

export default function LiveTracking() {

  const [locations, setLocations] = useState<Location[]>([])

  const token = `YOUR_TOKEN_HERE`

  useEffect(() => {
    async function fetchLocations() {
      try {
        const res = await axios.get<Location[]>(
          "https://rely-circles-designer-which.trycloudflare.com/api/geo/get-location",
          {
            headers: {
              Authorization: `Bearer ${token}`
            }
          }
        )

        setLocations(res.data)

      } catch (error) {
        console.error("Error fetching locations", error)
      }
    }

    fetchLocations()
  }, [])


  // websocket connection
  //  useEffect(() => {

  //   const ws = new WebSocket("ws://localhost:4000")

  //   ws.onopen = () => {
  //     console.log("WebSocket connected")
  //   }

  //   ws.onmessage = (event) => {

  //     console.log("WS message received")

  //     const riders = JSON.parse(event.data)

  //     setLocations(riders)

  //   }

  //   ws.onerror = (err) => {
  //     console.log("WS error", err)
  //   }

  //   ws.onclose = () => {
  //     console.log("WS closed")
  //   }

  //   // return () => ws.close()

  // }, [])


  console.log(locations)

  const deliveryIcon = new L.Icon({
    iconUrl: "https://maps.google.com/mapfiles/ms/icons/red-dot.png",
    iconSize: [32, 32],
    iconAnchor: [16, 32],
  })

  const warehouseIcon = new L.Icon({
    iconUrl: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
    iconSize: [32, 32],
    iconAnchor: [16, 32],
  })

  return (

    <div className="h-screen w-full">

      <MapContainer
        center={[18.5204, 73.8567]}
        zoom={12}
        className="h-full w-full"
      >

        <TileLayer
          attribution="© OpenStreetMap contributors"
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />

        {locations.map((loc, i) => (

          <Marker
            key={i}
            position={[loc.lat, loc.lng]}
            icon={loc.type === "rider" ? deliveryIcon : warehouseIcon}
          >

            <Popup>
              <strong>{loc.type}</strong>
              <br />
              Lat: {loc.lat}
              <br />
              Lng: {loc.lng}
            </Popup>

          </Marker>

        ))}

      </MapContainer>

    </div>
  )
}













// import { useEffect, useState } from "react"
// import { LOCATIONS } from "@/mockdata/data"
// import { MapContainer, Marker, Popup, TileLayer } from "react-leaflet"
// import L from "leaflet"
// import "leaflet/dist/leaflet.css"
// import MapControls from "./MapController"

// export default function LiveTracking() {
//   const [isDark, setIsDark] = useState(
//     document.documentElement.classList.contains("dark")
//   )

//   // Watch for Tailwind dark mode changes dynamically
//   useEffect(() => {
//     const observer = new MutationObserver(() => {
//       setIsDark(document.documentElement.classList.contains("dark"))
//     })

//     observer.observe(document.documentElement, {
//       attributes: true,
//       attributeFilter: ["class"],
//     })
//     return () => observer.disconnect()
//   }, [])

//   // Delivery and Warehouse icons
//   const deliveryIcon = new L.Icon({
//     iconUrl: "https://maps.google.com/mapfiles/ms/icons/red-dot.png",
//     iconSize: [32, 32],
//     iconAnchor: [16, 32],
//   })

//   const warehouseIcon = new L.Icon({
//     iconUrl: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
//     iconSize: [32, 32],
//     iconAnchor: [16, 32],
//   })

//   // Tile URLs and attribution based on theme
//   const tileUrl = isDark
//   ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
//   : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"

// const attribution = isDark
//   ? '&copy; <a href="https://carto.com/">CARTO</a> &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
//   : "© OpenStreetMap contributors"

//   return (
//     <div className="h-screen w-full relative overflow-x-hidden">
//       <MapContainer
//         center={[18.5204, 73.8567]}
//         zoom={12}
//         scrollWheelZoom={false}
//         doubleClickZoom={true}
//         touchZoom={true}
//         dragging={true}
//         className="h-full w-full"
//       >
//         <TileLayer attribution={attribution} url={tileUrl} />

//         {LOCATIONS.map((loc) => (
//           <Marker
//             key={loc.id}
//             position={[loc.lat, loc.lng]}
//             icon={loc.type === "delivery" ? deliveryIcon : warehouseIcon}
//           >
//             <Popup>
//               <strong>{loc.name}</strong>
//               <br />
//               Type: {loc.type}
//             </Popup>
//           </Marker>
//         ))}

//         <MapControls />
//       </MapContainer>
//     </div>
//   )
// }