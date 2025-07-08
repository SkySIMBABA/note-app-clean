import React, { useContext } from 'react';
import { NotesContext } from '../context/NotesContext';
import NoteCard from './NoteCard';
import { DndContext, closestCenter } from '@dnd-kit/core';
import { SortableContext, useSortable, arrayMove, verticalListSortingStrategy } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';

interface NoteListProps {
  onSelect: (id: string) => void;
  selectedNoteId: string | null;
  lang: 'en' | 'cn';
  onAddNew?: () => void;
}

function SortableNoteCard({ note, selected, onClick, id }: any) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } = useSortable({ id });
  return (
    <div
      ref={setNodeRef}
      style={{
        transform: CSS.Transform.toString(transform),
        transition,
        opacity: isDragging ? 0.5 : 1,
        zIndex: isDragging ? 99 : 'auto',
        touchAction: 'none',
      }}
    >
      <NoteCard
        note={note}
        selected={selected}
        onClick={onClick}
        dragHandleProps={attributes}
        dragListeners={listeners}
      />
    </div>
  );
}

export default function NoteList({ onSelect, selectedNoteId, lang, onAddNew }: NoteListProps) {
  const { notes, addNote, reorderNotes } = useContext(NotesContext);
  const addLabel = lang === 'en' ? '+ Add Note' : '+ 新建笔记';

  // Handler for Add Note button
  const handleAddNote = () => {
    addNote();
    if (onAddNew) onAddNew();
  };

  // Drag end handler
  const handleDragEnd = (event: any) => {
    const { active, over } = event;
    if (active.id !== over?.id) {
      const oldIndex = notes.findIndex(n => n.id === active.id);
      const newIndex = notes.findIndex(n => n.id === over.id);
      const newOrder = arrayMove(notes, oldIndex, newIndex);
      reorderNotes(newOrder);
    }
  };

  return (
    <div className="note-list">
      <button onClick={handleAddNote}>{addLabel}</button>
      <DndContext collisionDetection={closestCenter} onDragEnd={handleDragEnd}>
        <SortableContext items={notes.map(n => n.id)} strategy={verticalListSortingStrategy}>
          <div className="note-grid">
            {notes.map(note => (
              <SortableNoteCard
                key={note.id}
                id={note.id}
                note={note}
                selected={note.id === selectedNoteId}
                onClick={() => onSelect(note.id)}
              />
            ))}
          </div>
        </SortableContext>
      </DndContext>
    </div>
  );
} 