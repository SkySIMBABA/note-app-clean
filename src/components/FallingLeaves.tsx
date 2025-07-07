import React from 'react';
import leafImg from '../assets/leaf.png';

const NUM_LEAVES = 8;

function random(min: number, max: number) {
  return Math.random() * (max - min) + min;
}

export default function FallingLeaves() {
  return (
    <div style={{ position: 'fixed', inset: 0, pointerEvents: 'none', zIndex: 0 }}>
      {[...Array(NUM_LEAVES)].map((_, i) => {
        const left = random(0, 100);
        const duration = random(6, 14);
        const delay = random(0, 8);
        const size = random(24, 48);
        return (
          <img
            key={i}
            src={leafImg}
            alt="Leaf"
            style={{
              position: 'absolute',
              left: `${left}%`,
              top: '-60px',
              width: size,
              opacity: 0.7,
              animation: `leaf-fall ${duration}s linear ${delay}s infinite`,
              pointerEvents: 'none',
              zIndex: 0,
            }}
            className="falling-leaf"
          />
        );
      })}
    </div>
  );
} 