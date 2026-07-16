# Command: figma

Purpose: convert Figma design context into frontend code or inspect a Figma design.

Agent role: `figma`

Workflow:

1. Ask for Figma link/selection if not provided.
2. Use Figma MCP when available and approved.
3. Extract tokens, layout, typography, color, spacing, assets, and component structure.
4. Map to existing repo components first.
5. Implement with repo conventions after approval.
6. Verify build and browser behavior when possible.
