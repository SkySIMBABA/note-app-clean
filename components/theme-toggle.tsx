"use client"

import { Sun, Moon } from "lucide-react"
import { motion } from "framer-motion"
import { useTheme } from "@/contexts/theme-context"
import { Button } from "@/components/ui/button"

export default function ThemeToggle() {
  const { theme, toggleTheme, isTransitioning } = useTheme()
  const isDark = theme === "dark"

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={toggleTheme}
      disabled={isTransitioning}
      className={`w-9 h-9 rounded-full border transition-colors duration-300 ${
        isDark
          ? "bg-pink-950/30 border-pink-800/30 hover:bg-pink-900/40"
          : "bg-pink-100/70 border-pink-200 hover:bg-pink-200/70"
      }`}
    >
      <div className="relative w-5 h-5">
        {/* Sun icon */}
        <motion.div
          animate={{
            opacity: isDark ? 0 : 1,
            scale: isDark ? 0.5 : 1,
            rotate: isDark ? -45 : 0,
          }}
          transition={{ duration: 0.3 }}
          className="absolute inset-0 flex items-center justify-center"
        >
          <Sun className={`w-5 h-5 ${isDark ? "text-pink-300" : "text-pink-600"}`} />
        </motion.div>

        {/* Moon icon */}
        <motion.div
          animate={{
            opacity: isDark ? 1 : 0,
            scale: isDark ? 1 : 0.5,
            rotate: isDark ? 0 : 45,
          }}
          transition={{ duration: 0.3 }}
          className="absolute inset-0 flex items-center justify-center"
        >
          <Moon className={`w-5 h-5 ${isDark ? "text-pink-300" : "text-pink-700"}`} />
        </motion.div>
      </div>
    </Button>
  )
}
