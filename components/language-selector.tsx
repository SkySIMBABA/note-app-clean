"use client"

import { useState } from "react"
import { Globe, ChevronDown } from "lucide-react"
import { Button } from "@/components/ui/button"
import { motion, AnimatePresence } from "framer-motion"
import { useTheme } from "@/contexts/theme-context"

interface LanguageSelectorProps {
  lang: "zh" | "en"
  onLanguageChange: (lang: "zh" | "en") => void
}

export default function LanguageSelector({ lang, onLanguageChange }: LanguageSelectorProps) {
  const [isOpen, setIsOpen] = useState(false)
  const { theme } = useTheme()
  const isDark = theme === "dark"

  const languages = [
    { code: "zh" as const, name: "简体中文", flag: "🇨🇳" },
    { code: "en" as const, name: "English", flag: "🇺🇸" },
  ]

  const currentLanguage = languages.find((l) => l.code === lang)

  return (
    <div className="relative">
      <Button
        variant="ghost"
        onClick={() => setIsOpen(!isOpen)}
        className={`flex items-center gap-2 px-3 py-2 rounded-xl border transition-colors duration-1000 ${
          isDark
            ? "bg-pink-950/30 border-pink-800/30 hover:bg-pink-900/40"
            : "bg-pink-100/70 border-pink-200 hover:bg-pink-200/70"
        }`}
      >
        <Globe className={`w-4 h-4 transition-colors duration-1000 ${isDark ? "text-pink-300" : "text-pink-600"}`} />
        <span
          className={`text-sm font-medium transition-colors duration-1000 ${isDark ? "text-pink-100" : "text-pink-700"}`}
        >
          {currentLanguage?.flag}
        </span>
        <ChevronDown
          className={`w-4 h-4 transition-transform duration-200 transition-colors ${
            isOpen ? "rotate-180" : ""
          } ${isDark ? "text-pink-300" : "text-pink-600"}`}
        />
      </Button>

      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: -10, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -10, scale: 0.95 }}
            transition={{ duration: 0.2 }}
            className={`absolute top-full right-0 mt-2 backdrop-blur-xl rounded-2xl shadow-xl border overflow-hidden z-50 min-w-[160px] transition-colors duration-1000 ${
              isDark
                ? "bg-pink-950/40 border-pink-800/30 shadow-pink-900/20"
                : "bg-pink-50/80 border-pink-200/50 shadow-pink-300/20"
            }`}
          >
            {languages.map((language) => (
              <button
                key={language.code}
                onClick={() => {
                  onLanguageChange(language.code)
                  setIsOpen(false)
                }}
                className={`w-full px-4 py-3 text-left transition-colors duration-150 flex items-center gap-3 ${
                  lang === language.code
                    ? isDark
                      ? "bg-pink-800/30 text-pink-100"
                      : "bg-pink-200/70 text-pink-700"
                    : isDark
                      ? "text-pink-200 hover:bg-pink-900/30"
                      : "text-pink-700 hover:bg-pink-100/70"
                }`}
              >
                <span className="text-lg">{language.flag}</span>
                <span className="font-medium">{language.name}</span>
              </button>
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
