import React, { useContext } from 'react';
import { NotesContext, Note } from '../context/NotesContext';
import { calculateExpressions } from '../utils/calc';

interface NoteEditorProps {
  noteId: string | null;
  lang: 'en' | 'cn';
  onBack?: () => void; // for mobile navigation
}

export default function NoteEditor({ noteId, lang, onBack }: NoteEditorProps) {
  const { notes, updateNote, deleteNote } = useContext(NotesContext);
  const note = notes.find(n => n.id === noteId);

  const selectMsg = lang === 'en' ? 'Select a note to edit' : '请添加或选择要编辑的笔记';
  const deleteMsg = lang === 'en' ? 'Delete Note' : '删除笔记';

  if (!note) {
    return (
      <div className="note-editor" style={{ 
        display: 'flex', 
        alignItems: 'center', 
        justifyContent: 'center', 
        minHeight: '200px',
        textAlign: 'center',
        color: '#666',
        fontSize: '1.1rem'
      }}>
        {selectMsg}
      </div>
    );
  }

  const handleChange = (field: keyof Note, value: string) => {
    updateNote(note.id, { ...note, [field]: value });
  };

  const results = calculateExpressions(note.content);
  const total = results.reduce((sum, r) => sum + r.result, 0);

  return (
    <div className="note-editor-responsive">
      {/* Mobile back button */}
      {onBack && (
        <button
          className="back-btn"
          onClick={onBack}
          aria-label={lang === 'en' ? 'Back' : '返回'}
        >
          ←
        </button>
      )}
      <div className="editor-main">
        <input
          type="text"
          value={note.title}
          onChange={e => handleChange('title', e.target.value)}
          className="note-title-input"
          placeholder={lang === 'en' ? 'Title' : '标题'}
          style={{ marginTop: 8 }}
        />
        <textarea
          value={note.content}
          onChange={e => handleChange('content', e.target.value)}
          className="note-content-input"
          placeholder={lang === 'en' ? 'Write your note here...\n\nYou can also write calculations like:\n10 + 20\n30 * 2\n100 / 4' : '在这里写下你的笔记...\n\n你也可以写计算式，比如：\n10 + 20\n30 * 2\n100 / 4'}
          rows={12}
          style={{ 
            minHeight: '200px',
            resize: 'vertical',
            fontFamily: 'inherit'
          }}
        />
        <div className="editor-bottom-row">
          <button
            onClick={() => deleteNote(note.id)}
            className="delete-note-btn left-bottom icon-only"
            title={deleteMsg}
            aria-label={deleteMsg}
          >
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="3 6 5 6 21 6"/>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"/>
              <line x1="10" y1="11" x2="10" y2="17"/>
              <line x1="14" y1="11" x2="14" y2="17"/>
            </svg>
          </button>
        </div>
      </div>
      {/* Calculation panel on the right (desktop/tablet), below (mobile) */}
      {results.length > 0 && (
        <div className="calc-panel-responsive">
          <div style={{ 
            fontWeight: 600, 
            fontSize: '1.2em', 
            textAlign: 'right',
            color: '#7c3aed',
            marginBottom: 8
          }}>
            {lang === 'en' ? 'Total' : '合计'}: <span style={{ fontSize: '1.4em' }}>¥{total.toLocaleString()}</span>
          </div>
          {/* Always show calculation breakdown if there is at least one calculation */}
          <div style={{ 
            marginTop: '12px', 
            fontSize: '0.9rem',
            color: '#666'
          }}>
            <div style={{ fontWeight: 600, marginBottom: '8px' }}>
              {lang === 'en' ? 'Calculations' : '计算明细'}:
            </div>
            {results.map((result, index) => (
              <div key={index} style={{ 
                display: 'flex', 
                justifyContent: 'space-between',
                padding: '4px 0',
                borderBottom: '1px solid rgba(124, 58, 237, 0.1)'
              }}>
                <span>{result.expression}</span>
                <span style={{ fontWeight: 500 }}>{result.result}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

// CSS (to add to styles.css):
/*
.note-editor-responsive {
  display: flex;
  flex-direction: column;
  position: relative;
}
.editor-main {
  flex: 1;
  display: flex;
  flex-direction: column;
}
.calc-panel-responsive {
  margin-top: 24px;
}
@media (min-width: 769px) {
  .note-editor-responsive {
    flex-direction: row;
    gap: 32px;
    align-items: flex-start;
  }
  .editor-main {
    flex: 2;
  }
  .calc-panel-responsive {
    flex: 1;
    margin-top: 0;
    margin-left: 32px;
    min-width: 220px;
    max-width: 300px;
    background: rgba(124, 58, 237, 0.07);
    border-radius: 16px;
    padding: 20px 18px;
    border: 1px solid rgba(124, 58, 237, 0.13);
    box-shadow: 0 2px 8px rgba(124,58,237,0.04);
  }
}
*/