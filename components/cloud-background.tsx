"use client"

import { useEffect, useState } from "react"

export default function CloudBackground() {
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
      {/* Animated cloud background */}
      <div className="absolute inset-0">
        {/* Large drifting clouds */}
        <div className="absolute top-20 left-10 text-8xl opacity-10 animate-drift">☁️</div>
        <div
          className="absolute top-32 right-20 text-9xl opacity-8 animate-drift-slow"
          style={{ animationDelay: "2s" }}
        >
          ☁️
        </div>
        <div className="absolute top-48 left-1/3 text-7xl opacity-12 animate-drift" style={{ animationDelay: "4s" }}>
          ☁️
        </div>
        <div
          className="absolute top-16 right-1/3 text-8xl opacity-10 animate-drift-slow"
          style={{ animationDelay: "1s" }}
        >
          ☁️
        </div>

        {/* Medium clouds */}
        <div className="absolute top-64 left-1/4 text-6xl opacity-15 animate-float">☁️</div>
        <div className="absolute top-80 right-1/4 text-5xl opacity-12 animate-float" style={{ animationDelay: "3s" }}>
          ☁️
        </div>

        {/* Sky elements */}
        <div className="absolute top-40 left-1/5 text-3xl opacity-25 animate-float">🌤️</div>
        <div className="absolute top-72 right-1/5 text-2xl opacity-20 animate-float" style={{ animationDelay: "2s" }}>
          ⛅
        </div>
        <div className="absolute top-96 left-3/4 text-3xl opacity-25 animate-float" style={{ animationDelay: "4s" }}>
          🌤️
        </div>

        {/* Twinkling stars/sparkles */}
        <div className="absolute top-28 right-1/6 text-xl opacity-30 animate-twinkle">✨</div>
        <div className="absolute top-56 left-1/6 text-lg opacity-25 animate-twinkle" style={{ animationDelay: "1.5s" }}>
          ✨
        </div>
        <div className="absolute top-84 right-2/3 text-xl opacity-30 animate-twinkle" style={{ animationDelay: "3s" }}>
          ✨
        </div>

        {/* Floating cloud silhouette that follows mouse */}
        <div
          className="absolute text-6xl opacity-5 transition-all duration-1000 ease-out"
          style={{
            left: `${15 + (mousePosition.x / window.innerWidth) * 15}%`,
            top: `${50 + (mousePosition.y / window.innerHeight) * 15}%`,
          }}
        >
          ☁️
        </div>

        {/* Cloud particles */}
        <div
          className="absolute top-1/4 left-1/6 w-3 h-3 bg-blue-200/30 rounded-full animate-bounce"
          style={{ animationDelay: "0s", animationDuration: "4s" }}
        />
        <div
          className="absolute top-1/2 right-1/6 w-2 h-2 bg-sky-200/40 rounded-full animate-bounce"
          style={{ animationDelay: "1s", animationDuration: "5s" }}
        />
        <div
          className="absolute top-2/3 left-1/2 w-2.5 h-2.5 bg-blue-100/50 rounded-full animate-bounce"
          style={{ animationDelay: "2s", animationDuration: "6s" }}
        />
        <div
          className="absolute top-3/4 right-1/3 w-2 h-2 bg-white/60 rounded-full animate-bounce"
          style={{ animationDelay: "0.5s", animationDuration: "4.5s" }}
        />
      </div>

      {/* Gradient overlays for sky depth */}
      <div className="absolute inset-0 bg-gradient-to-t from-white/10 via-transparent to-blue-50/20" />
      <div className="absolute inset-0 bg-gradient-to-r from-sky-50/20 via-transparent to-blue-50/20" />
    </div>
  )
}
