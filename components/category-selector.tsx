"use client"

import { useState, useEffect, useRef } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { useTheme } from "@/contexts/theme-context"
import { useAnimation } from "@/contexts/animation-context"
import { useDropdown } from "@/app/page"
import { ChevronDown } from "lucide-react"
import Image from "next/image"

interface Category {
  id: string
  name: string
  icon: string
  emoji: string
}

interface CategorySelectorProps {
  id: string
  selectedCategory: string
  onSelectCategory: (category: string) => void
}

export default function CategorySelector({ id, selectedCategory, onSelectCategory }: CategorySelectorProps) {
  const [isOpen, setIsOpen] = useState(false)
  const { theme } = useTheme()
  const { getAnimationProps, isEnabled } = useAnimation()
  const isDark = theme === "dark"
  const { setIsAnyDropdownOpen, activeDropdown, setActiveDropdown, isMobileView } = useDropdown()
  const dropdownRef = useRef<HTMLDivElement>(null)
  const buttonRef = useRef<HTMLButtonElement>(null)

  // Update the global dropdown state when this dropdown opens/closes
  useEffect(() => {
    if (isOpen) {
      setIsAnyDropdownOpen(true)
      setActiveDropdown(id)
    } else if (activeDropdown === id) {
      setActiveDropdown(null)
      setIsAnyDropdownOpen(false)
    }
  }, [isOpen, setIsAnyDropdownOpen, setActiveDropdown, id, activeDropdown])

  // Close this dropdown if another one opens
  useEffect(() => {
    if (activeDropdown && activeDropdown !== id) {
      setIsOpen(false)
    }
  }, [activeDropdown, id])

  const categories: Category[] = [
    { id: "all", name: "All Notes", icon: "/images/totoro.png", emoji: "📝" },
    { id: "food", name: "Food", icon: "/images/totoro.png", emoji: "🍽️" },
    { id: "shopping", name: "Shopping", icon: "/images/leaf.png", emoji: "🛍️" },
    { id: "travel", name: "Travel", icon: "/images/totoro.png", emoji: "✈️" },
    { id: "work", name: "Work", icon: "/images/leaf.png", emoji: "💼" },
    { id: "personal", name: "Personal", icon: "/images/totoro.png", emoji: "💭" },
  ]

  const selectedCat = categories.find((cat) => cat.id === selectedCategory) || categories[0]

  // Calculate dropdown position
  const [dropdownPosition, setDropdownPosition] = useState({ top: 0, left: 0, width: 0 })

  useEffect(() => {
    if (isOpen && buttonRef.current) {
      const rect = buttonRef.current.getBoundingClientRect()

      // On mobile, position the dropdown in the center of the screen
      if (isMobileView) {
        setDropdownPosition({
          top: window.innerHeight / 2 - 150,
          left: window.innerWidth / 2 - 150,
          width: 300,
        })
      } else {
        setDropdownPosition({
          top: rect.bottom + window.scrollY + 8,
          left: rect.left,
          width: rect.width,
        })
      }
    }
  }, [isOpen, isMobileView])

  return (
    <div className="relative z-[60]">
      <motion.button
        ref={buttonRef}
        onClick={() => setIsOpen(!isOpen)}
        className={`flex items-center gap-3 px-4 py-3 rounded-2xl backdrop-blur-md border transition-all duration-300 ${
          isDark
            ? "bg-pink-950/30 border-pink-800/30 hover:bg-pink-900/40"
            : "bg-pink-100/70 border-pink-200 hover:bg-pink-200/70"
        }`}
        {...getAnimationProps("hover")}
      >
        <motion.div className="relative w-8 h-8" {...(isEnabled ? getAnimationProps("sway") : {})}>
          {selectedCat.id === "all" || selectedCat.id === "food" || selectedCat.id === "personal" ? (
            <Image src="/images/totoro.png" alt={selectedCat.name} width={32} height={32} />
          ) : (
            <Image src="/images/leaf.png" alt={selectedCat.name} width={32} height={32} />
          )}
        </motion.div>
        <span className={`font-medium transition-colors duration-300 ${isDark ? "text-pink-100" : "text-pink-900"}`}>
          {selectedCat.name}
        </span>
        <ChevronDown
          className={`w-4 h-4 transition-transform ${isOpen ? "rotate-180" : ""} ${
            isDark ? "text-pink-300" : "text-pink-600"
          }`}
        />
      </motion.button>

      <AnimatePresence>
        {isOpen && (
          <>
            {/* Mobile overlay backdrop */}
            {isMobileView && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="fixed inset-0 bg-black/40 backdrop-blur-sm z-[998]"
              />
            )}

            <motion.div
              ref={dropdownRef}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              transition={{ duration: 0.2 }}
              className={`fixed p-2 rounded-2xl backdrop-blur-xl border shadow-lg z-[999] ${
                isDark
                  ? "bg-pink-950/40 border-pink-800/30 shadow-pink-900/20"
                  : "bg-pink-50/80 border-pink-200 shadow-pink-300/20"
              }`}
              style={{
                top: dropdownPosition.top,
                left: dropdownPosition.left,
                width: isMobileView ? dropdownPosition.width : "auto",
                maxWidth: "90vw",
              }}
            >
              {/* Mobile header */}
              {isMobileView && (
                <div className={`px-4 py-3 border-b mb-2 ${isDark ? "border-pink-800/30" : "border-pink-200/60"}`}>
                  <div className="flex justify-between items-center">
                    <h3 className={`font-medium ${isDark ? "text-pink-100" : "text-pink-800"}`}>Select Category</h3>
                    <button
                      onClick={() => setIsOpen(false)}
                      className={`p-2 rounded-full ${isDark ? "hover:bg-pink-800/30" : "hover:bg-pink-200/60"}`}
                    >
                      <ChevronDown className={`w-5 h-5 rotate-180 ${isDark ? "text-pink-300" : "text-pink-600"}`} />
                    </button>
                  </div>
                </div>
              )}

              <div className={isMobileView ? "max-h-[60vh] overflow-y-auto p-2" : ""}>
                {categories.map((category) => (
                  <motion.button
                    key={category.id}
                    onClick={() => {
                      onSelectCategory(category.id)
                      setIsOpen(false)
                    }}
                    className={`flex items-center gap-3 w-full px-3 ${
                      isMobileView ? "py-4" : "py-2.5"
                    } rounded-xl transition-colors ${
                      selectedCategory === category.id
                        ? isDark
                          ? "bg-pink-800/30 text-white"
                          : "bg-pink-200/70 text-pink-900"
                        : isDark
                          ? "hover:bg-pink-900/30 text-pink-100"
                          : "hover:bg-pink-100 text-pink-800"
                    }`}
                    {...getAnimationProps("hover")}
                  >
                    <motion.div
                      className={`relative ${isMobileView ? "w-8 h-8" : "w-6 h-6"}`}
                      {...(isEnabled ? getAnimationProps("sway") : {})}
                    >
                      {category.id === "all" || category.id === "food" || category.id === "personal" ? (
                        <Image
                          src="/images/totoro.png"
                          alt={category.name}
                          width={isMobileView ? 32 : 24}
                          height={isMobileView ? 32 : 24}
                        />
                      ) : (
                        <Image
                          src="/images/leaf.png"
                          alt={category.name}
                          width={isMobileView ? 32 : 24}
                          height={isMobileView ? 32 : 24}
                        />
                      )}
                    </motion.div>
                    <span className={`font-medium ${isMobileView ? "text-base" : ""}`}>{category.name}</span>

                    {/* Selected indicator */}
                    {selectedCategory === category.id && (
                      <div className="ml-auto">
                        <div className={`w-2 h-2 rounded-full ${isDark ? "bg-pink-400" : "bg-pink-500"}`} />
                      </div>
                    )}
                  </motion.button>
                ))}
              </div>

              {/* Mobile footer */}
              {isMobileView && (
                <div className="mt-2 pt-2 border-t border-pink-800/30">
                  <button
                    onClick={() => setIsOpen(false)}
                    className={`w-full py-3 rounded-xl font-medium ${
                      isDark
                        ? "bg-pink-800/30 text-pink-100 active:bg-pink-700/30"
                        : "bg-pink-200/70 text-pink-800 active:bg-pink-300/70"
                    }`}
                  >
                    Close
                  </button>
                </div>
              )}
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  )
}
