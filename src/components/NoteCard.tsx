import React, { useContext } from 'react';
import { Note, NotesContext } from '../context/NotesContext';
import { motion } from 'framer-motion';
import { useSwipeable } from 'react-swipeable';

interface NoteCardProps {
  note: Note;
  selected: boolean;
  onClick: () => void;
  dragHandleProps?: React.HTMLAttributes<HTMLDivElement>;
  dragListeners?: any;
}

// Helper function to extract and evaluate calculation from a line
function extractCalculation(line: string) {
  // Match the last math expression in the line (e.g., Dinner 50+1)
  const match = line.match(/([\d+\-*/().\s]+)$/);
  if (match) {
    try {
      const result = eval(match[1]);
      if (typeof result === 'number' && !isNaN(result)) {
        return { expression: match[1].trim(), result };
      }
    } catch (e) {
      // Invalid expression, skip
    }
  }
  return null;
}

function useIsMobile() {
  if (typeof window === 'undefined') return false;
  return window.innerWidth < 769;
}

export default function NoteCard({ note, selected, onClick, dragHandleProps, dragListeners }: NoteCardProps) {
  const { deleteNote } = useContext(NotesContext);
  const isMobile = useIsMobile();
  const [swiped, setSwiped] = React.useState(false);
  const [isSwiping, setIsSwiping] = React.useState(false);

  // Only show title in grid/list view (desktop/tablet)
  // But for calculation, parse all lines for possible calculations
  const results = note.content
    .split('\n')
    .map(line => extractCalculation(line))
    .filter(Boolean) as { expression: string; result: number }[];
  const total = results.reduce((sum, r) => sum + r.result, 0);

  function handleDelete() {
    const confirmed = window.confirm('确定要删除这条笔记吗？\nAre you sure you want to delete this note?');
    if (confirmed) {
      deleteNote(note.id);
    } else {
      setSwiped(false);
    }
  }

  const handlers = useSwipeable({
    onSwipedLeft: () => { setSwiped(true); setTimeout(handleDelete, 250); setIsSwiping(false); },
    onSwipedRight: () => { setSwiped(true); setTimeout(handleDelete, 250); setIsSwiping(false); },
    onSwiping: (e) => { setIsSwiping(true); },
    onTouchEndOrOnMouseUp: () => { setIsSwiping(false); },
    delta: 60, // minimum distance(px) before a swipe is detected
    trackTouch: true,
    trackMouse: false,
  });

  const showDeleteBg = isSwiping || swiped;

  const card = (
    <div style={{ position: 'relative', display: 'flex', alignItems: 'center' }}>
      {/* Drag handle */}
      {(dragHandleProps || dragListeners) && (
        <div
          {...dragHandleProps}
          {...dragListeners}
          style={{
            cursor: 'grab',
            marginLeft: 4,
            marginRight: 8,
            userSelect: 'none',
            display: 'flex',
            alignItems: 'center',
            height: 44,
            width: 44,
            borderRadius: '50%',
            background: 'rgba(124,58,237,0.08)',
            transition: 'background 0.2s, box-shadow 0.2s',
            boxShadow: '0 1px 4px rgba(124,58,237,0.07)',
            justifyContent: 'center',
            zIndex: 2,
          }}
          aria-label="Drag to reorder"
          tabIndex={-1}
          className="note-drag-handle"
        >
          <svg width="22" height="22" viewBox="0 0 22 22" fill="none" stroke="#a3a3a3" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{ display: 'block' }}>
            <line x1="6" y1="7" x2="16" y2="7" />
            <line x1="6" y1="11" x2="16" y2="11" />
            <line x1="6" y1="15" x2="16" y2="15" />
          </svg>
        </div>
      )}
      {/* Delete background with trash icon */}
      {showDeleteBg && (
        <div style={{
          position: 'absolute',
          inset: 0,
          background: 'linear-gradient(90deg, #f87171 0%, #ef4444 100%)',
          borderRadius: 16,
          zIndex: 0,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          pointerEvents: 'none',
        }}>
          <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
            <polyline points="3 6 5 6 21 6"/>
            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"/>
            <line x1="10" y1="11" x2="10" y2="17"/>
            <line x1="14" y1="11" x2="14" y2="17"/>
          </svg>
        </div>
      )}
      <motion.div
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
        whileHover={{ y: -6, boxShadow: '0 8px 24px rgba(124,58,237,0.13)' }}
        whileTap={{ scale: 0.97 }}
        transition={{ type: 'spring', stiffness: 300, damping: 20 }}
        animate={swiped ? { x: 400, opacity: 0 } : { x: 0, opacity: 1 }}
        style={{ touchAction: 'pan-y', position: 'relative', zIndex: 1, flex: 1 }}
      >
        <div className="note-card-title-row">
          <h3 className="note-card-title">{note.title || 'Untitled'}</h3>
        </div>
        {/* Hide calculation total and breakdown in grid/list view, but keep calculation logic for future use */}
      </motion.div>
    </div>
  );

  return isMobile ? (
    <div {...handlers}>{card}</div>
  ) : card;
} 