"use client"

import { useState } from "react"
import { Calendar, MoreHorizontal } from "lucide-react"
import { Button } from "@/components/ui/button"
import { useRouter } from "next/navigation"
import { motion } from "framer-motion"
import { useTheme } from "@/contexts/theme-context"
import { useAnimation } from "@/contexts/animation-context"
import Image from "next/image"

interface Note {
  id: string
  name: string
  content: string
  total: number
  date: Date
  category?: string
}

interface NoteCardProps {
  note: Note
  lang: "zh" | "en"
}

export default function NoteCard({ note, lang }: NoteCardProps) {
  const router = useRouter()
  const [isPressed, setIsPressed] = useState(false)
  const [isHovered, setIsHovered] = useState(false)
  const { theme } = useTheme()
  const { getAnimationProps, isEnabled } = useAnimation()
  const isDark = theme === "dark"

  const formatTotal = (total: number) => {
    return new Intl.NumberFormat(lang === "zh" ? "zh-CN" : "en-US").format(total)
  }

  const getCategoryIcon = (category?: string) => {
    switch (category) {
      case "food":
      case "personal":
        return "/images/totoro.png"
      case "shopping":
      case "travel":
      case "work":
        return "/images/leaf.png"
      default:
        return "/images/totoro.png"
    }
  }

  return (
    <motion.div
      className="relative z-10"
      onMouseDown={() => setIsPressed(true)}
      onMouseUp={() => setIsPressed(false)}
      onMouseLeave={() => {
        setIsPressed(false)
        setIsHovered(false)
      }}
      onMouseEnter={() => setIsHovered(true)}
      onClick={() => router.push(`/note/${note.id}`)}
      {...getAnimationProps("hover")}
      role="button"
      tabIndex={0}
      aria-label={`Open note: ${note.name}`}
      style={{ cursor: "pointer" }}
    >
      {/* Card background with glassmorphism */}
      <div
        className={`backdrop-blur-xl rounded-3xl p-6 border transition-all duration-1000 relative overflow-hidden ${
          isDark ? "bg-pink-950/20 border-pink-800/20" : "bg-pink-50/60 border-pink-200/60"
        }`}
        style={{
          boxShadow: isHovered
            ? isDark
              ? "0 20px 40px -20px rgba(236, 72, 153, 0.3), 0 0 16px rgba(236, 72, 153, 0.1) inset"
              : "0 20px 40px -20px rgba(236, 72, 153, 0.2), 0 0 16px rgba(255, 255, 255, 0.2) inset"
            : isDark
              ? "0 10px 30px -15px rgba(0, 0, 0, 0.3), 0 0 10px rgba(255, 255, 255, 0.05) inset"
              : "0 10px 30px -15px rgba(0, 0, 0, 0.1), 0 0 10px rgba(255, 255, 255, 0.2) inset",
        }}
      >
        {/* Ambient glow */}
        <div
          className={`absolute inset-0 transition-opacity duration-300 ${isHovered ? "opacity-100" : "opacity-0"} ${
            isDark
              ? "bg-gradient-to-br from-pink-600/5 to-pink-800/5"
              : "bg-gradient-to-br from-pink-300/10 to-pink-500/10"
          }`}
        />

        {/* Subtle pattern overlay */}
        <div className="absolute top-0 right-0 w-20 h-20 opacity-5">
          <div className="text-6xl transform rotate-12">✨</div>
        </div>

        {/* Header */}
        <div className="flex items-start justify-between mb-4 relative z-10">
          <div className="flex items-center gap-3">
            <motion.div
              className={`w-8 h-8 rounded-full flex items-center justify-center backdrop-blur-sm border transition-colors duration-1000 ${
                isDark
                  ? "bg-gradient-to-br from-pink-800/20 to-pink-700/20 border-pink-700/20"
                  : "bg-gradient-to-br from-pink-200/60 to-pink-300/60 border-pink-200/60"
              }`}
              {...(isEnabled ? getAnimationProps("sway") : {})}
            >
              <Image
                src={getCategoryIcon(note.category) || "/placeholder.svg"}
                alt={note.category || "Note"}
                width={24}
                height={24}
              />
            </motion.div>
            <div>
              <h3
                className={`font-semibold text-lg leading-tight transition-colors duration-1000 ${
                  isDark ? "text-pink-100" : "text-pink-800"
                }`}
              >
                {note.name}
              </h3>
              <div
                className={`flex items-center gap-1 text-xs mt-1 transition-colors duration-1000 ${
                  isDark ? "text-pink-300/70" : "text-pink-600/70"
                }`}
              >
                <Calendar className="w-3 h-3" />
                <span>{note.date.toLocaleDateString(lang === "zh" ? "zh-CN" : "en-US")}</span>
              </div>
            </div>
          </div>

          <Button
            variant="ghost"
            size="sm"
            className={`opacity-0 group-hover:opacity-100 transition-opacity duration-200 w-8 h-8 p-0 rounded-full ${
              isDark ? "hover:bg-pink-800/30" : "hover:bg-pink-200/60"
            }`}
          >
            <MoreHorizontal
              className={`w-4 h-4 transition-colors duration-1000 ${isDark ? "text-pink-300" : "text-pink-600"}`}
            />
          </Button>
        </div>

        {/* Content Preview */}
        {note.content && (
          <div className="mb-4 relative z-10">
            <p
              className={`text-sm line-clamp-3 leading-relaxed transition-colors duration-1000 ${
                isDark ? "text-pink-200/70" : "text-pink-700"
              }`}
            >
              {note.content}
            </p>
          </div>
        )}

        {/* Total with futuristic pill */}
        {note.total > 0 && (
          <div className="flex justify-end relative z-10">
            <div
              className={`bg-gradient-to-r text-white px-4 py-2 rounded-full text-sm font-semibold transition-all duration-1000 ${
                isDark ? "from-pink-500 to-pink-600" : "from-pink-400 to-pink-500"
              }`}
              style={{
                boxShadow: isDark
                  ? "0 4px 12px -2px rgba(236, 72, 153, 0.3), 0 0 4px rgba(255, 255, 255, 0.2) inset"
                  : "0 4px 12px -2px rgba(236, 72, 153, 0.2), 0 0 4px rgba(255, 255, 255, 0.4) inset",
              }}
            >
              ¥{formatTotal(note.total)}
            </div>
          </div>
        )}

        {/* Animated Totoro/Leaf elements */}
        <>
          {note.category === "food" || note.category === "personal" || !note.category ? (
            <motion.div className="absolute bottom-2 right-2 opacity-10 z-0" {...getAnimationProps("float")}>
              <Image src="/images/totoro.png" alt="Totoro" width={40} height={40} />
            </motion.div>
          ) : (
            <motion.div className="absolute bottom-2 right-2 opacity-10 z-0" {...getAnimationProps("float")}>
              <Image src="/images/leaf.png" alt="Leaf" width={32} height={32} />
            </motion.div>
          )}
        </>
      </div>
    </motion.div>
  )
}
