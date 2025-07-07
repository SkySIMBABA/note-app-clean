import { evaluate } from 'mathjs';

export function calculateExpressions(content: string) {
  const lines = content.split('\n');
  return lines
    .map(line => {
      const match = line.match(/([\d\+\-\*\/\.]+)$/);
      if (match) {
        try {
          return { expression: match[1], result: evaluate(match[1]) };
        } catch {
          return null;
        }
      }
      return null;
    })
    .filter(Boolean) as { expression: string; result: number }[];
}