# Hermes MCP Setup

This file transfers the OpenCode MCP intent into Hermes-readable setup guidance.

## Desired MCPs

- LSP: enabled when Hermes or the host supports language-server tools.
- Playwright: browser/UI testing.
- Figma: design context when explicitly needed.
- Animotion/animation tools: optional for animation/icon discovery.
- Excalidraw: optional diagrams.
- Blender: disabled by default; enable only for explicit 3D work.

## OpenCode Source Configuration

The OpenCode config used:

```json
{
  "lsp": true,
  "mcp": {
    "playwright": {
      "type": "local",
      "command": ["npx", "-y", "@playwright/mcp@latest"],
      "enabled": true
    },
    "figma": {
      "type": "remote",
      "url": "https://mcp.figma.com/mcp",
      "enabled": true
    },
    "animotion": {
      "type": "local",
      "command": ["npx", "-y", "animotion-mcp"],
      "enabled": true
    },
    "excalidraw": {
      "type": "local",
      "command": ["npx", "-y", "@cmd8/excalidraw-mcp"],
      "enabled": false
    },
    "blender-mcp": {
      "type": "local",
      "command": ["uvx", "blender-mcp"],
      "enabled": false
    }
  }
}
```

## Hermes Rule

Hermes should use these MCPs only when connected and approved. Do not install or enable optional MCPs silently.
