// Verifica que AGENTS.md y CLAUDE.md tengan exactamente el mismo contenido.
import { readFileSync } from 'node:fs';

const [claude, agents] = ['CLAUDE.md', 'AGENTS.md'].map((file) => readFileSync(file, 'utf8'));

if (claude !== agents) {
	console.error('Error: AGENTS.md y CLAUDE.md difieren. Copiá CLAUDE.md sobre AGENTS.md.');
	process.exit(1);
}

console.log('AGENTS.md y CLAUDE.md son idénticos.');
