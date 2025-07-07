"use client"

import { useEffect, useRef, useState } from "react"
import { motion } from "framer-motion"
import { useTheme } from "@/contexts/theme-context"
import { useAnimation } from "@/contexts/animation-context"
import Image from "next/image"

interface FuturisticBackgroundProps {
  scrollY: number
}

export default function FuturisticBackground({ scrollY }: FuturisticBackgroundProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const { theme } = useTheme()
  const { intensity, getAnimationProps, isEnabled } = useAnimation()
  const isDark = theme === "dark"
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 })

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      setMousePosition({ x: e.clientX, y: e.clientY })
    }
    window.addEventListener("mousemove", handleMouseMove)
    return () => window.removeEventListener("mousemove", handleMouseMove)
  }, [])

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas) return

    const ctx = canvas.getContext("2d")
    if (!ctx) return

    // Set canvas dimensions
    const resizeCanvas = () => {
      canvas.width = window.innerWidth
      canvas.height = window.innerHeight
    }

    resizeCanvas()
    window.addEventListener("resize", resizeCanvas)

    // Create grid points
    const gridSize = 40
    const points = []
    const cols = Math.ceil(canvas.width / gridSize) + 1
    const rows = Math.ceil(canvas.height / gridSize) + 1

    for (let i = 0; i < cols; i++) {
      for (let j = 0; j < rows; j++) {
        points.push({
          x: i * gridSize,
          y: j * gridSize,
          originX: i * gridSize,
          originY: j * gridSize,
          offset: Math.random() * 20 - 10,
          speed: Math.random() * 0.2 + 0.1,
        })
      }
    }

    // Animation loop
    let animationId: number
    let time = 0

    const animate = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height)

      // Skip animation if disabled
      if (!isEnabled || intensity === "off") {
        animationId = requestAnimationFrame(animate)
        return
      }

      // Animation intensity factors
      const intensityFactors = {
        subtle: 0.5,
        normal: 1,
        playful: 1.5,
      }

      // const factor = intensityFactors[intensity as keyof typeof intensityFactors] || 0
      // Always use the playful factor (1.5)
      const factor = 1.5

      // Draw grid with theme-aware colors
      ctx.strokeStyle = isDark ? "rgba(236, 72, 153, 0.03)" : "rgba(219, 39, 119, 0.03)"
      ctx.lineWidth = 1

      // Horizontal lines
      for (let j = 0; j < rows; j++) {
        ctx.beginPath()
        for (let i = 0; i < cols; i++) {
          const point = points[i + j * cols]
          const offsetY = Math.sin(time * point.speed + point.offset) * 5 * factor
          const y = point.y + offsetY + scrollY * 0.1 * factor

          if (i === 0) {
            ctx.moveTo(point.x, y)
          } else {
            ctx.lineTo(point.x, y)
          }
        }
        ctx.stroke()
      }

      // Vertical lines
      for (let i = 0; i < cols; i++) {
        ctx.beginPath()
        for (let j = 0; j < rows; j++) {
          const point = points[i + j * cols]
          const offsetY = Math.sin(time * point.speed + point.offset) * 5 * factor
          const y = point.y + offsetY + scrollY * 0.1 * factor

          if (j === 0) {
            ctx.moveTo(point.x, y)
          } else {
            ctx.lineTo(point.x, y)
          }
        }
        ctx.stroke()
      }

      // Draw glowing points with theme-aware colors
      for (let i = 0; i < cols; i++) {
        for (let j = 0; j < rows; j++) {
          const point = points[i + j * cols]
          const offsetY = Math.sin(time * point.speed + point.offset) * 5 * factor
          const y = point.y + offsetY + scrollY * 0.1 * factor

          const glowSize = Math.sin(time * 0.5 + i * 0.2 + j * 0.1) * 0.5 + 0.5

          // Only draw some points for performance
          if ((i + j) % 5 === 0) {
            const gradient = ctx.createRadialGradient(point.x, y, 0, point.x, y, 4 * glowSize * factor)

            if (isDark) {
              gradient.addColorStop(0, "rgba(236, 72, 153, 0.4)")
              gradient.addColorStop(1, "rgba(236, 72, 153, 0)")
            } else {
              gradient.addColorStop(0, "rgba(219, 39, 119, 0.3)")
              gradient.addColorStop(1, "rgba(219, 39, 119, 0)")
            }

            ctx.fillStyle = gradient
            ctx.beginPath()
            ctx.arc(point.x, y, 4 * glowSize * factor, 0, Math.PI * 2)
            ctx.fill()
          }
        }
      }

      time += 0.01 * factor
      animationId = requestAnimationFrame(animate)
    }

    animate()

    return () => {
      window.removeEventListener("resize", resizeCanvas)
      cancelAnimationFrame(animationId)
    }
  }, [scrollY, theme, intensity, isEnabled])

  return (
    <div className="fixed inset-0 pointer-events-none overflow-hidden">
      {/* Canvas for grid animation */}
      <canvas ref={canvasRef} className="absolute inset-0 z-0" />

      {/* Gradient overlays with theme-aware colors */}
      <div
        className={`absolute inset-0 z-10 transition-colors duration-1000 ${
          isDark
            ? "bg-gradient-to-b from-pink-950/20 via-transparent to-pink-900/20"
            : "bg-gradient-to-b from-pink-100/30 via-transparent to-pink-200/30"
        }`}
      />

      {/* Totoro elements */}
      {isEnabled && (
        <>
          <motion.div
            className="absolute z-10"
            style={{
              left: `${20 + (mousePosition.x / window.innerWidth) * 10}%`,
              top: `${60 + (mousePosition.y / window.innerHeight) * 10}%`,
            }}
            {...getAnimationProps("float")}
          >
            <Image
              src="/images/totoro.png"
              alt="Totoro"
              width={120}
              height={120}
              className={`opacity-10 transition-opacity duration-1000 ${isDark ? "opacity-10" : "opacity-5"}`}
            />
          </motion.div>

          {/* Leaf elements */}
          <motion.div className="absolute z-10 right-[15%] top-[30%]" {...getAnimationProps("float")}>
            <Image
              src="/images/leaf.png"
              alt="Leaf"
              width={80}
              height={80}
              className={`opacity-10 transition-opacity duration-1000 ${isDark ? "opacity-10" : "opacity-5"}`}
            />
          </motion.div>

          <motion.div className="absolute z-10 left-[25%] top-[20%]" {...getAnimationProps("float")}>
            <Image
              src="/images/leaf.png"
              alt="Leaf"
              width={60}
              height={60}
              className={`opacity-10 transition-opacity duration-1000 ${isDark ? "opacity-10" : "opacity-5"}`}
            />
          </motion.div>
        </>
      )}

      {/* Ambient glow effects with theme-aware colors */}
      <motion.div
        className={`absolute top-1/4 left-1/4 w-96 h-96 rounded-full blur-3xl z-0 transition-colors duration-1000 ${
          isDark ? "bg-pink-600/10" : "bg-pink-400/10"
        }`}
        {...getAnimationProps("pulse")}
      />

      <motion.div
        className={`absolute bottom-1/3 right-1/4 w-64 h-64 rounded-full blur-3xl z-0 transition-colors duration-1000 ${
          isDark ? "bg-pink-600/10" : "bg-pink-400/10"
        }`}
        {...getAnimationProps("pulse")}
      />
    </div>
  )
}
