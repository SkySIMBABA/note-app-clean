import React, { useContext } from 'react';
import { NotesContext } from '../context/NotesContext';
import NoteCard from './NoteCard';

interface NoteListProps {
  onSelect: (id: string) => void;
  selectedNoteId: string | null;
  lang: 'en' | 'cn';
}

export default function NoteList({ onSelect, selectedNoteId, lang }: NoteListProps) {
  const { notes, addNote } = useContext(NotesContext);
  const addLabel = lang === 'en' ? '+ Add Note' : '+ 新建笔记';

  return (
    <div className="note-list">
      <button onClick={addNote}>{addLabel}</button>
      {notes.map(note => (
        <NoteCard
          key={note.id}
          note={note}
          selected={note.id === selectedNoteId}
          onClick={() => onSelect(note.id)}
        />
      ))}
    </div>
  );
} 