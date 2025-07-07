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

export default function App() {
  const [selectedNoteId, setSelectedNoteId] = useState<string | null>(null);
  const [lang, setLang] = useState<'en' | 'cn'>('en');
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  useEffect(() => {
    document.body.classList.remove('light', 'dark');
    document.body.classList.add(theme);
  }, [theme]);

  const title = lang === 'en' ? 'DUODUO Note' : '朵朵记笔记';
  const subtitle = lang === 'en' ? 'Cozy Note & Calc App' : '温馨记事与计算';

  return (
    <NotesProvider>
      <FallingLeaves />
      <div className="app-root">
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
    </NotesProvider>
  );
}
