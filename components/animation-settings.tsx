"use client"

import { useState, useEffect, useRef } from "react"
import { motion } from "framer-motion"
import { useAnimation } from "@/contexts/animation-context"
import { useTheme } from "@/contexts/theme-context"
import { Sparkles, Zap, Leaf, ChevronDown } from "lucide-react"
import { useDropdown } from "@/app/page"
import Image from "next/image"

interface AnimationSettingsProps {
  id: string
}

export default function AnimationSettings({ id }: AnimationSettingsProps) {
  const { intensity, setIntensity, getAnimationProps } = useAnimation()
  const { theme } = useTheme()
  const isDark = theme === "dark"
  const [isOpen, setIsOpen] = useState(false)
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

  const intensityOptions = [
    { value: "off", label: "Off", icon: <Zap className="w-4 h-4" /> },
    { value: "subtle", label: "Subtle", icon: <Leaf className="w-4 h-4" /> },
    { value: "normal", label: "Normal", icon: <Sparkles className="w-4 h-4" /> },
    {
      value: "playful",
      label: "Playful",
      icon: (
        <div className="w-4 h-4 relative">
          <Image src="/images/totoro.png" alt="Totoro" width={16} height={16} />
        </div>
      ),
    },
  ]

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
        <motion.div
          className={`w-8 h-8 rounded-full flex items-center justify-center transition-colors duration-1000 ${
            isDark ? "bg-pink-800/30" : "bg-pink-200/70"
          }`}
          {...getAnimationProps("sway")}
        >
          <Sparkles className={`w-4 h-4 ${isDark ? "text-pink-300" : "text-pink-600"}`} />
        </motion.div>
        <div className="flex flex-col">
          <span className={`text-sm font-medium ${isDark ? "text-pink-100" : "text-pink-900"}`}>Animation</span>
          <span className={`text-xs ${isDark ? "text-pink-300/70" : "text-pink-600/70"}`}>
            {intensityOptions.find((opt) => opt.value === intensity)?.label}
          </span>
        </div>
        <ChevronDown
          className={`w-4 h-4 ml-1 transition-transform ${isOpen ? "rotate-180" : ""} ${
            isDark ? "text-pink-300" : "text-pink-600"
          }`}
        />
      </motion.button>

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
                  <h3 className={`font-medium ${isDark ? "text-pink-100" : "text-pink-800"}`}>Animation Settings</h3>
                  <button
                    onClick={() => setIsOpen(false)}
                    className={`p-2 rounded-full ${isDark ? "hover:bg-pink-800/30" : "hover:bg-pink-200/60"}`}
                  >
                    <ChevronDown className={`w-5 h-5 rotate-180 ${isDark ? "text-pink-300" : "text-pink-600"}`} />
                  </button>
                </div>
              </div>
            )}

            <div className={isMobileView ? "max-h-[60vh] overflow-y-auto p-2" : "space-y-1"}>
              {intensityOptions.map((option) => (
                <motion.button
                  key={option.value}
                  onClick={() => {
                    setIntensity(option.value as any)
                    setIsOpen(false)
                  }}
                  className={`flex items-center gap-3 w-full px-3 ${
                    isMobileView ? "py-4" : "py-2.5"
                  } rounded-xl transition-colors ${
                    intensity === option.value
                      ? isDark
                        ? "bg-pink-800/30 text-white"
                        : "bg-pink-200/70 text-pink-900"
                      : isDark
                        ? "hover:bg-pink-900/30 text-pink-100"
                        : "hover:bg-pink-100 text-pink-800"
                  }`}
                  {...getAnimationProps("hover")}
                >
                  <div
                    className={`${isMobileView ? "w-10 h-10" : "w-6 h-6"} rounded-full flex items-center justify-center ${
                      isDark ? "bg-pink-800/50" : "bg-pink-200"
                    }`}
                  >
                    {option.icon}
                  </div>
                  <span className={`font-medium ${isMobileView ? "text-base" : ""}`}>{option.label}</span>

                  {/* Preview animation */}
                  {option.value !== "off" && (
                    <motion.div
                      className="ml-auto"
                      animate={{
                        y:
                          option.value === "subtle"
                            ? [-2, 2, -2]
                            : option.value === "normal"
                              ? [-4, 4, -4]
                              : [-6, 6, -6],
                      }}
                      transition={{
                        duration: option.value === "subtle" ? 2 : option.value === "normal" ? 1.5 : 1,
                        repeat: Number.POSITIVE_INFINITY,
                        repeatType: "reverse",
                      }}
                    >
                      <div className={`${isMobileView ? "w-6 h-6" : "w-4 h-4"} relative`}>
                        <Image
                          src="/images/leaf.png"
                          alt="Leaf"
                          width={isMobileView ? 24 : 16}
                          height={isMobileView ? 24 : 16}
                        />
                      </div>
                    </motion.div>
                  )}

                  {/* Selected indicator */}
                  {intensity === option.value && isMobileView && (
                    <div className="ml-2">
                      <div className={`w-2 h-2 rounded-full ${isDark ? "bg-pink-400" : "bg-pink-500"}`} />
                    </div>
                  )}
                </motion.button>
              ))}
            </div>

            <div className={`mt-3 pt-3 border-t ${isDark ? "border-pink-800/30" : "border-pink-200"}`}>
              <div className={`text-xs ${isDark ? "text-pink-300/70" : "text-pink-600/70"} text-center px-2 pb-1`}>
                Adjust animation intensity throughout the app
              </div>

              {/* Mobile footer */}
              {isMobileView && (
                <div className="mt-2">
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
            </div>
          </motion.div>
        </>
      )}
    </div>
  )
}
