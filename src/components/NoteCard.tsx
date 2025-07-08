import React from 'react';
import { Note } from '../context/NotesContext';

interface NoteCardProps {
  note: Note;
  selected: boolean;
  onClick: () => void;
}

export default function NoteCard({ note, selected, onClick }: NoteCardProps) {
  const results = calculateExpressions(note.content);
  const total = results.reduce((sum, r) => sum + r.result, 0);

  return (
    <div 
      className={`note-card ${selected ? 'selected' : ''}`}
      onClick={onClick}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          onClick();
        }
      }}
      aria-label={`Note: ${note.title}`}
    >
      <div className="note-card-content">
        <h3>{note.title || 'Untitled'}</h3>
        {note.content && (
          <p style={{ 
            margin: '8px 0', 
            color: '#666', 
            fontSize: '0.95rem',
            lineHeight: '1.4',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            display: '-webkit-box',
            WebkitLineClamp: 2,
            WebkitBoxOrient: 'vertical'
          }}>
            {note.content}
          </p>
        )}
      </div>
      
      {total > 0 && (
        <div className="note-total">
          ¥{total.toLocaleString()}
        </div>
      )}
      
      {results.length > 0 && (
        <div className="note-card-details">
          <ul>
            {results.map((result, index) => (
              <li key={index}>
                <span>{result.expression}</span>
                <span>{result.result}</span>
              </li>
            ))}
          </ul>
          <div className="total">¥{total.toLocaleString()}</div>
        </div>
      )}
    </div>
  );
}

// Helper function to calculate expressions (moved from utils for simplicity)
function calculateExpressions(content: string) {
  const results: { expression: string; result: number }[] = [];
  const lines = content.split('\n');
  
  lines.forEach(line => {
    const trimmed = line.trim();
    if (trimmed.match(/^[\d+\-*/().\s]+$/)) {
      try {
        const result = eval(trimmed);
        if (typeof result === 'number' && !isNaN(result)) {
          results.push({ expression: trimmed, result });
        }
      } catch (e) {
        // Invalid expression, skip
      }
    }
  });
  
  return results;
} 