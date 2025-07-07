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

  if (!note) {
    return <div className="note-editor">{selectMsg}</div>;
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
          top: 24,
          right: 24,
          width: 40,
          height: 40,
          borderRadius: '50%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          padding: 0,
          fontSize: 22,
        }}
        title={lang === 'en' ? 'Delete Note' : '删除笔记'}
      >
        {/* Trash SVG icon */}
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
      </button>
      <input
        type="text"
        value={note.title}
        onChange={e => handleChange('title', e.target.value)}
        className="note-title-input"
        placeholder={lang === 'en' ? 'Title' : '标题'}
      />
      <textarea
        value={note.content}
        onChange={e => handleChange('content', e.target.value)}
        className="note-content-input"
        placeholder={lang === 'en' ? 'Write your note here...' : '在这里写下你的笔记...'}
        rows={10}
      />
      <div className="calc-panel">
        {results.length > 0 && (
          <div style={{ fontWeight: 600, fontSize: '1.2em', textAlign: 'right' }}>
            {lang === 'en' ? 'Total' : '合计'}: <span>{total}</span>
          </div>
        )}
      </div>
    </div>
  );
}