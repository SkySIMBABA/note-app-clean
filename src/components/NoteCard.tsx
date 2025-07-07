import React from 'react';
import { Note } from '../context/NotesContext';
import { calculateExpressions } from '../utils/calc';

interface NoteCardProps {
  note: Note;
  selected: boolean;
  onClick: () => void;
}

export default function NoteCard({ note, selected, onClick }: NoteCardProps) {
  // Calculate total sum for this note
  const results = calculateExpressions(note.content);
  const total = results.reduce((sum, r) => sum + r.result, 0);

  return (
    <div className={`note-card${selected ? ' selected' : ''}`} onClick={onClick} style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', minHeight: 80 }}>
      <div style={{ flex: 1 }}>
        <h3>{note.title}</h3>
        {/* Show only total in the middle part if there are results */}
        {results.length > 0 && (
          <div style={{ fontWeight: 600, fontSize: '1.1em', marginTop: 8 }}>
            Total: <span>{total}</span>
          </div>
        )}
      </div>
      {/* Details breakdown on the right */}
      {results.length > 0 && (
        <div style={{ minWidth: 120, marginLeft: 16, borderLeft: '1px solid #eee', paddingLeft: 12, fontSize: '0.98em', display: 'flex', flexDirection: 'column', alignItems: 'flex-end' }}>
          <ul style={{ margin: 0, padding: 0, listStyle: 'none', width: '100%' }}>
            {results.map((r, i) => (
              <li key={i} style={{ display: 'flex', justifyContent: 'space-between', width: '100%', marginBottom: 2 }}>
                <span style={{ color: '#888', marginRight: 8 }}>{r.expression}</span>
                <span style={{ fontWeight: 500 }}>{r.result}</span>
              </li>
            ))}
          </ul>
          <div style={{ fontWeight: 600, fontSize: '1em', marginTop: 8, textAlign: 'right', width: '100%' }}>
            Total: <span>{total}</span>
          </div>
        </div>
      )}
    </div>
  );
} 