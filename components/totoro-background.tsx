"use client"

import { useEffect, useState } from "react"

export default function TotoroBackground() {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 })

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      setMousePosition({ x: e.clientX, y: e.clientY })
    }

    window.addEventListener("mousemove", handleMouseMove)
    return () => window.removeEventListener("mousemove", handleMouseMove)
  }, [])

  return (
    <div className="fixed inset-0 pointer-events-none overflow-hidden">
      {/* Animated forest background */}
      <div className="absolute inset-0">
        {/* Large trees */}
        <div className="absolute bottom-0 left-10 text-8xl opacity-10 animate-sway">🌲</div>
        <div className="absolute bottom-0 right-20 text-9xl opacity-10 animate-sway" style={{ animationDelay: "1s" }}>
          🌳
        </div>
        <div className="absolute bottom-0 left-1/3 text-7xl opacity-10 animate-sway" style={{ animationDelay: "2s" }}>
          🌲
        </div>
        <div
          className="absolute bottom-0 right-1/3 text-8xl opacity-10 animate-sway"
          style={{ animationDelay: "0.5s" }}
        >
          🌳
        </div>

        {/* Floating leaves */}
        <div className="absolute top-20 left-1/4 text-2xl opacity-30 animate-float">🍃</div>
        <div className="absolute top-40 right-1/4 text-xl opacity-30 animate-float" style={{ animationDelay: "2s" }}>
          🍂
        </div>
        <div className="absolute top-60 left-3/4 text-2xl opacity-30 animate-float" style={{ animationDelay: "4s" }}>
          🍃
        </div>

        {/* Totoro silhouette */}
        <div
          className="absolute text-6xl opacity-5 transition-all duration-1000 ease-out"
          style={{
            left: `${20 + (mousePosition.x / window.innerWidth) * 10}%`,
            top: `${60 + (mousePosition.y / window.innerHeight) * 10}%`,
          }}
        >
          🐻
        </div>

        {/* Soot sprites */}
        <div
          className="absolute top-1/3 left-1/5 w-2 h-2 bg-gray-800/20 rounded-full animate-bounce"
          style={{ animationDelay: "0s", animationDuration: "3s" }}
        />
        <div
          className="absolute top-1/2 right-1/5 w-1.5 h-1.5 bg-gray-800/20 rounded-full animate-bounce"
          style={{ animationDelay: "1s", animationDuration: "4s" }}
        />
        <div
          className="absolute top-2/3 left-1/2 w-2 h-2 bg-gray-800/20 rounded-full animate-bounce"
          style={{ animationDelay: "2s", animationDuration: "5s" }}
        />
      </div>

      {/* Gradient overlays for depth */}
      <div className="absolute inset-0 bg-gradient-to-t from-white/20 via-transparent to-transparent" />
      <div className="absolute inset-0 bg-gradient-to-r from-green-50/30 via-transparent to-emerald-50/30" />
    </div>
  )
}
