import React, { useContext } from 'react';
import { NotesContext, Note } from '../context/NotesContext';
import { calculateExpressions } from '../utils/calc';

interface NoteEditorProps {
  noteId: string | null;
  lang: 'en' | 'cn';
}

export default function NoteEditor({ noteId, lang }: NoteEditorProps) {
  const { notes, updateNote, deleteNote } = useContext(NotesContext);
  const note = notes.find(n => n.id === noteId);

  const selectMsg = lang === 'en' ? 'Select a note to edit' : '请选择要编辑的笔记';
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
    <div className="note-editor" style={{ position: 'relative' }}>
      {/* Delete button at top right */}
      <button
        onClick={() => deleteNote(note.id)}
        className="delete-note-btn"
        style={{
          position: 'absolute',
          top: 16,
          right: 16,
          width: 48,
          height: 48,
          borderRadius: '50%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          padding: 0,
          fontSize: 20,
          zIndex: 10,
        }}
        title={deleteMsg}
        aria-label={deleteMsg}
      >
        {/* Trash SVG icon */}
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
          <polyline points="3 6 5 6 21 6"/>
          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"/>
          <line x1="10" y1="11" x2="10" y2="17"/>
          <line x1="14" y1="11" x2="14" y2="17"/>
        </svg>
      </button>
      
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
      
      {results.length > 0 && (
        <div className="calc-panel" style={{ 
          background: 'rgba(124, 58, 237, 0.1)', 
          padding: '16px 20px', 
          borderRadius: '14px',
          marginTop: '16px',
          border: '1px solid rgba(124, 58, 237, 0.2)'
        }}>
          <div style={{ 
            fontWeight: 600, 
            fontSize: '1.2em', 
            textAlign: 'right',
            color: '#7c3aed'
          }}>
            {lang === 'en' ? 'Total' : '合计'}: <span style={{ fontSize: '1.4em' }}>¥{total.toLocaleString()}</span>
          </div>
          
          {results.length > 1 && (
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
          )}
        </div>
      )}
    </div>
  );
}