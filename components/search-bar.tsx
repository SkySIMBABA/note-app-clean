"use client"

import { Search } from "lucide-react"
import { motion } from "framer-motion"
import { useTheme } from "@/contexts/theme-context"

interface SearchBarProps {
  value: string
  onChange: (value: string) => void
  placeholder: string
}

export default function SearchBar({ value, onChange, placeholder }: SearchBarProps) {
  const { theme } = useTheme()
  const isDark = theme === "dark"

  return (
    <motion.div
      className="relative"
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.2, duration: 0.5 }}
    >
      <div
        className={`absolute left-4 top-1/2 transform -translate-y-1/2 transition-colors duration-1000 ${
          isDark ? "text-pink-300" : "text-pink-500"
        }`}
      >
        <Search className="w-5 h-5" />
      </div>
      <input
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className={`w-full pl-12 pr-4 py-4 backdrop-blur-md border rounded-2xl focus:outline-none focus:ring-2 transition-all duration-1000 ${
          isDark
            ? "bg-pink-950/20 border-pink-800/20 text-pink-100 placeholder-pink-300/50 focus:ring-pink-500/30 focus:border-pink-500/30"
            : "bg-pink-50/60 border-pink-200/60 text-pink-900 placeholder-pink-500/50 focus:ring-pink-500/20 focus:border-pink-500/20"
        }`}
      />

      {/* Subtle glow effect */}
      <div
        className={`absolute inset-0 -z-10 rounded-2xl blur-lg opacity-50 transition-colors duration-1000 ${
          isDark ? "bg-pink-500/5" : "bg-pink-500/10"
        }`}
      />
    </motion.div>
  )
}
