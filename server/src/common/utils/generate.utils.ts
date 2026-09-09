import axios from "axios"

export async function calculateDistanceAndTime(
  pickupLat: number,
  pickupLng: number,
  dropLat: number,
  dropLng: number
) {
  const response = await axios.get(
    "https://maps.googleapis.com/maps/api/distancematrix/json",
    {
      params: {
        origins: `${pickupLat},${pickupLng}`,
        destinations: `${dropLat},${dropLng}`,
        key: process.env.GOOGLE_MAP_KEY
      }
    }
  )

  const element = response.data.rows?.[0]?.elements?.[0]

  if (!element || element.status !== "OK") {
    throw new Error("Distance calculation failed")
  }

  return {
    distanceKm: element.distance.value / 1000,
    durationMin: element.duration.value / 60
  }
}