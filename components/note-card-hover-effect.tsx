"use client"

import type React from "react"

import { useState, useRef } from "react"

interface HoverEffectProps {
  children: React.ReactNode
}

export default function NoteCardHoverEffect({ children }: HoverEffectProps) {
  const [isHovered, setIsHovered] = useState(false)
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 })
  const cardRef = useRef<HTMLDivElement>(null)

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!cardRef.current) return

    const rect = cardRef.current.getBoundingClientRect()
    setMousePosition({
      x: e.clientX - rect.left,
      y: e.clientY - rect.top,
    })
  }

  return (
    <div
      ref={cardRef}
      className="relative overflow-hidden rounded-3xl"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onMouseMove={handleMouseMove}
    >
      {/* Subtle highlight effect that follows cursor */}
      {isHovered && (
        <div
          className="absolute pointer-events-none bg-white/10 blur-xl rounded-full w-32 h-32 -translate-x-1/2 -translate-y-1/2 transition-opacity duration-300"
          style={{
            left: mousePosition.x,
            top: mousePosition.y,
            opacity: 0.4,
          }}
        />
      )}

      {/* Card content */}
      {children}
    </div>
  )
}
