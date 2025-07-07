import React, { createContext, useState, useEffect } from 'react';
import { v4 as uuidv4 } from 'uuid';

export interface Note {
  id: string;
  title: string;
  content: string;
}

interface NotesContextType {
  notes: Note[];
  addNote: () => void;
  updateNote: (id: string, updated: Note) => void;
  deleteNote: (id: string) => void;
}

export const NotesContext = createContext<NotesContextType>({
  notes: [],
  addNote: () => {},
  updateNote: () => {},
  deleteNote: () => {},
});

export const NotesProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [notes, setNotes] = useState<Note[]>(() => {
    const saved = localStorage.getItem('notes');
    return saved ? JSON.parse(saved) : [];
  });

  useEffect(() => {
    localStorage.setItem('notes', JSON.stringify(notes));
  }, [notes]);

  const addNote = () => {
    const newNote = { id: uuidv4(), title: 'New Note', content: '' };
    setNotes([newNote, ...notes]);
  };

  const updateNote = (id: string, updated: Note) => {
    setNotes(notes.map(n => (n.id === id ? updated : n)));
  };

  const deleteNote = (id: string) => {
    setNotes(notes.filter(n => n.id !== id));
  };

  return (
    <NotesContext.Provider value={{ notes, addNote, updateNote, deleteNote }}>
      {children}
    </NotesContext.Provider>
  );
};