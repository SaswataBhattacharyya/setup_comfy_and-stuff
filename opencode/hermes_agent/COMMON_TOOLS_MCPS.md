# Common Tools and MCPs

Hermes should use tools to reduce guessing, not to add complexity.

## LSP

Use LSP for definitions, references, diagnostics, symbol search, and rename impact. Prefer LSP over raw text search when relationships matter.

## Playwright

Use Playwright for browser/UI verification:

- navigation
- forms
- buttons
- modals
- accessibility tree
- console/runtime errors
- responsive layout

Ask before starting a dev server if one is not already running.

## Graphify

Use Graphify for architecture and dependency questions when a current graph exists. See `COMMON_GRAPHIFY.md`.

## GSAP and Animation Tools

Use GSAP only when timeline control, scroll choreography, or complex animation sequencing is required. Prefer CSS transitions/keyframes for simple hover, reveal, and microinteraction work.

## Figma

Use Figma MCP when the user provides a Figma file/frame or asks to push/pull design context. Map design to existing components and tokens first.

## Excalidraw / FigJam

Use editable diagram tools for architecture sketches and flow diagrams when the user asks for visual planning.

## Blender

Use Blender MCP only when explicitly requested and the local Blender MCP environment is ready.

## Tool Safety

- Do not install MCPs or dependencies without approval.
- Do not enable disabled optional tools without approval.
- Do not run destructive tool actions without approval.
- Prefer read-only inspection before mutation.
