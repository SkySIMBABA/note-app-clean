import React from 'react';
import ThemeToggle from './ThemeToggle';

export default function Sidebar() {
  return (
    <aside className="sidebar">
      <h2>Totoro Calculator</h2>
      <ThemeToggle />
      <div style={{ marginTop: 20, color: '#888' }}>Settings coming soon!</div>
    </aside>
  );
}