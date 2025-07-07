"use client"

import { useEffect, useState } from "react"

export default function TotoroLeafDecoration() {
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 })
  const [leaves, setLeaves] = useState<
    { id: number; x: number; y: number; size: number; rotation: number; delay: number }[]
  >([])

  useEffect(() => {
    // Generate random leaves
    const newLeaves = Array.from({ length: 12 }, (_, i) => ({
      id: i,
      x: Math.random() * 100,
      y: Math.random() * 100,
      size: Math.random() * 1.5 + 0.5,
      rotation: Math.random() * 360,
      delay: Math.random() * 5,
    }))
    setLeaves(newLeaves)

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
        {/* Totoro silhouette that follows mouse */}
        <div
          className="absolute text-8xl opacity-5 transition-all duration-1000 ease-out"
          style={{
            left: `${20 + (mousePosition.x / window.innerWidth) * 10}%`,
            top: `${60 + (mousePosition.y / window.innerHeight) * 10}%`,
            transform: `rotate(${mousePosition.x / 100}deg)`,
          }}
        >
          🐻
        </div>

        {/* Floating leaves */}
        {leaves.map((leaf) => (
          <div
            key={leaf.id}
            className="absolute text-2xl opacity-20 animate-float"
            style={{
              left: `${leaf.x}%`,
              top: `${leaf.y}%`,
              fontSize: `${leaf.size}rem`,
              transform: `rotate(${leaf.rotation}deg)`,
              animationDelay: `${leaf.delay}s`,
              animationDuration: `${5 + leaf.delay}s`,
            }}
          >
            {leaf.id % 3 === 0 ? "🍃" : leaf.id % 3 === 1 ? "🌿" : "🍂"}
          </div>
        ))}

        {/* Soot sprites */}
        <div
          className="absolute bottom-20 right-20 w-2 h-2 bg-gray-800/10 rounded-full animate-bounce"
          style={{ animationDuration: "3s" }}
        />
        <div
          className="absolute bottom-24 right-32 w-1.5 h-1.5 bg-gray-800/10 rounded-full animate-bounce"
          style={{ animationDelay: "0.5s", animationDuration: "2.5s" }}
        />
        <div
          className="absolute bottom-16 right-28 w-1 h-1 bg-gray-800/10 rounded-full animate-bounce"
          style={{ animationDelay: "1s", animationDuration: "2s" }}
        />
      </div>
    </div>
  )
}
