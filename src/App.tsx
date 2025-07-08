// src/App.tsx
import React, { useState, useEffect } from 'react';
import NoteList from './components/NoteList';
import NoteEditor from './components/NoteEditor';
import { NotesProvider } from './context/NotesContext';
import totoroImg from './assets/totoro.png';
import treeImg from './assets/tree.png';
import leafImg from './assets/leaf.png';
import FallingLeaves from './components/FallingLeaves';
import './styles.css';
import { motion } from 'framer-motion';

function useIsMobile() {
  const [isMobile, setIsMobile] = useState(window.innerWidth < 769);
  useEffect(() => {
    const onResize = () => setIsMobile(window.innerWidth < 769);
    window.addEventListener('resize', onResize);
    return () => window.removeEventListener('resize', onResize);
  }, []);
  return isMobile;
}

export default function App() {
  const [selectedNoteId, setSelectedNoteId] = useState<string | null>(null);
  const [lang, setLang] = useState<'en' | 'cn'>('en');
  const [theme, setTheme] = useState<'light' | 'dark'>('light');
  const [mobileScreen, setMobileScreen] = useState<'list' | 'editor'>('list');
  const isMobile = useIsMobile();

  useEffect(() => {
    document.body.classList.remove('light', 'dark');
    document.body.classList.add(theme);
  }, [theme]);

  const title = lang === 'en' ? '💭 Note' : '💭笔记';
  const subtitle = lang === 'en' ? 'Cozy Note & Calc App' : '温馨记事与计算';

  // Handler for selecting a note or adding a new note
  const handleSelectNote = (id: string | null) => {
    setSelectedNoteId(id);
    if (isMobile) setMobileScreen('editor');
  };
  // Handler for back button in editor
  const handleBack = () => {
    setMobileScreen('list');
    setSelectedNoteId(null);
  };

  return (
    <NotesProvider>
      <FallingLeaves />
      <motion.div className="app-root" initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.6 }}>
        {/* Mobile Header */}
        <header className="mobile-header">
          <div className="mobile-header-content">
            <div className="mobile-header-left">
              <img src={totoroImg} alt="Totoro" className="mobile-totoro" />
              <div>
                <h1 className="mobile-title">{title}</h1>
                <p className="mobile-subtitle">
                  <span role="img" aria-label="leaf">🍃</span> {subtitle}
                </p>
              </div>
            </div>
            <div className="mobile-controls">
              <button
                className="theme-toggle-btn"
                style={{ 
                  background: lang === 'en' ? '#a3b18a' : '#e9e5c9', 
                  color: lang === 'en' ? '#fff' : '#5b7c3a',
                  padding: '8px 12px',
                  fontSize: '0.9rem'
                }}
                onClick={() => setLang('en')}
              >
                EN
              </button>
              <button
                className="theme-toggle-btn"
                style={{ 
                  background: lang === 'cn' ? '#a3b18a' : '#e9e5c9', 
                  color: lang === 'cn' ? '#fff' : '#5b7c3a',
                  padding: '8px 12px',
                  fontSize: '0.9rem'
                }}
                onClick={() => setLang('cn')}
              >
                中文
              </button>
              <button
                className="theme-toggle-btn"
                style={{ 
                  background: theme === 'dark' ? '#232946' : '#e9e5c9', 
                  color: theme === 'dark' ? '#fff' : '#5b7c3a',
                  padding: '8px 12px',
                  fontSize: '0.9rem'
                }}
                onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
              >
                {theme === 'dark' ? '☀️' : '🌙'}
              </button>
            </div>
          </div>
        </header>

        {/* Mobile Content: Two-screen navigation */}
        {isMobile && (
          <main className="mobile-content">
            {/* Add Note button with animation */}
            <motion.button
              className="add-note-btn"
              whileTap={{ scale: 0.93 }}
              style={{ width: '100%', margin: '16px 0', padding: '12px 0', fontSize: '1.1em', fontWeight: 600, borderRadius: 12, background: 'linear-gradient(90deg, #a5b4fc 0%, #f0abfc 100%)', color: '#fff', border: 'none', boxShadow: '0 2px 8px rgba(124,58,237,0.08)' }}
              onClick={() => handleSelectNote(null)}
            >
              + Add Note
            </motion.button>
            {mobileScreen === 'list' && (
              <section className="mobile-notes-section">
                <NoteList 
                  onSelect={id => handleSelectNote(id)} 
                  selectedNoteId={selectedNoteId} 
                  lang={lang} 
                  onAddNew={() => handleSelectNote(null)}
                />
              </section>
            )}
            {mobileScreen === 'editor' && (
              <section className="mobile-editor-section">
                <NoteEditor noteId={selectedNoteId} lang={lang} onBack={handleBack} />
              </section>
            )}
          </main>
        )}

        {/* Desktop Layout */}
        {!isMobile && (
          <div className="desktop-layout">
            <aside className="sidebar" style={{ position: 'relative' }}>
              {/* Totoro image with animation */}
              <img src={totoroImg} alt="Totoro" className="totoro-animated" style={{ width: 80, margin: '0 auto 18px auto', display: 'block' }} />
              {/* Tree decoration bottom left */}
              <img src={treeImg} alt="Tree" style={{ width: 40, position: 'absolute', left: 10, bottom: 30, zIndex: 1 }} />
              {/* Leaf decoration top right */}
              <img src={leafImg} alt="Leaf" style={{ width: 30, position: 'absolute', right: 10, top: 20, transform: 'rotate(-20deg)', zIndex: 1 }} />
              <h2>{title}</h2>
              <div style={{ color: '#5b7c3a', fontSize: '1.1em', marginBottom: 16 }}>
                <span role="img" aria-label="leaf">🍃</span> {subtitle}
              </div>
              <div style={{ marginBottom: 16 }}>
                <button
                  className="theme-toggle-btn"
                  style={{ marginRight: 8, background: lang === 'en' ? '#a3b18a' : '#e9e5c9', color: lang === 'en' ? '#fff' : '#5b7c3a' }}
                  onClick={() => setLang('en')}
                >
                  EN
                </button>
                <button
                  className="theme-toggle-btn"
                  style={{ background: lang === 'cn' ? '#a3b18a' : '#e9e5c9', color: lang === 'cn' ? '#fff' : '#5b7c3a' }}
                  onClick={() => setLang('cn')}
                >
                  中文
                </button>
                <button
                  className="theme-toggle-btn"
                  style={{ marginLeft: 8, background: theme === 'dark' ? '#232946' : '#e9e5c9', color: theme === 'dark' ? '#fff' : '#5b7c3a' }}
                  onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
                >
                  {theme === 'dark' ? '☀️ Light' : '🌙 Dark'}
                </button>
              </div>
            </aside>
            <main style={{ position: 'relative' }}>
              {/* Faint Totoro decoration bottom right */}
              <img src={totoroImg} alt="Totoro" style={{ width: 60, position: 'absolute', right: 20, bottom: 20, opacity: 0.13, pointerEvents: 'none', zIndex: 0 }} />
              <NoteList onSelect={setSelectedNoteId} selectedNoteId={selectedNoteId} lang={lang} />
              <NoteEditor noteId={selectedNoteId} lang={lang} />
            </main>
          </div>
        )}
      </motion.div>
    </NotesProvider>
  );
}
