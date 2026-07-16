---
name: electron-app
description: Build and debug Electron apps with preload, main process, renderer process, IPC, and Vite integration.
compatibility: opencode
---

## Goal

Make safe Electron changes.

## Workflow

1. Identify main process, preload, renderer, and package scripts.
2. Check IPC handlers and exposed preload APIs.
3. Avoid duplicate IPC handlers.
4. Keep Node APIs out of renderer unless safely exposed through preload.
5. Run build/dev commands if available.
6. Summarize changed files and verification.

## Rules

- Prefer contextBridge in preload.
- Do not expose unrestricted filesystem or shell access to renderer.
- Keep IPC names consistent.
