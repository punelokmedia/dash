"use client"

import { useMap } from "react-leaflet"
import "leaflet/dist/leaflet.css"
import { ArrowUp, ArrowDown, ArrowLeft, ArrowRight, ZoomIn, ZoomOut } from "lucide-react"

// Controls Component
export default function MapControls() {
  const map = useMap()
  const step = 0.02 // move step in degrees
  const zoomStep = 1

  return (
    <div className="absolute bottom-5 right-5 z-[1000] flex flex-col gap-2">
      {/* Zoom Controls */}
      <div className="flex flex-col gap-1">
        <button
          onClick={() => map.setZoom(map.getZoom() + zoomStep)}
          className="bg-white border border-gray-300 rounded-md w-12 h-12 flex items-center justify-center shadow-md hover:bg-gray-100"
        >
          <ZoomIn size={24} />
        </button>
        <button
          onClick={() => map.setZoom(map.getZoom() - zoomStep)}
          className="bg-white border border-gray-300 rounded-md w-12 h-12 flex items-center justify-center shadow-md hover:bg-gray-100"
        >
          <ZoomOut size={24} />
        </button>
      </div>

      {/* Pan Controls */}
      <div className="flex flex-col gap-1 mt-2">
        <button
          onClick={() => map.panBy([0, -100])}
          className="bg-white border border-gray-300 rounded-md w-12 h-12 flex items-center justify-center shadow-md hover:bg-gray-100"
        >
          <ArrowUp size={24} />
        </button>
        <div className="flex gap-1">
          <button
            onClick={() => map.panBy([-100, 0])}
            className="bg-white border border-gray-300 rounded-md w-12 h-12 flex items-center justify-center shadow-md hover:bg-gray-100"
          >
            <ArrowLeft size={24} />
          </button>
          <button
            onClick={() => map.panBy([100, 0])}
            className="bg-white border border-gray-300 rounded-md w-12 h-12 flex items-center justify-center shadow-md hover:bg-gray-100"
          >
            <ArrowRight size={24} />
          </button>
        </div>
        <button
          onClick={() => map.panBy([0, 100])}
          className="bg-white border border-gray-300 rounded-md w-12 h-12 flex items-center justify-center shadow-md hover:bg-gray-100"
        >
          <ArrowDown size={24} />
        </button>
      </div>
    </div>
  )
}