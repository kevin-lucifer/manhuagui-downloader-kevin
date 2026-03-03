# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Tauri v2** desktop application for downloading comics from manhuagui.com (漫画柜). It uses a React + TypeScript frontend and a Rust backend.

## Tech Stack

- **Frontend**: React 18, TypeScript, Ant Design 5, UnoCSS, Vite
- **Backend**: Rust with Tauri v2, Tokio, Reqwest
- **Package Manager**: pnpm (specified in package.json as `pnpm@9.5.0`)

## Common Commands

### Development

```bash
# Install dependencies
pnpm install

# Run in development mode (starts Vite dev server + Tauri)
pnpm tauri dev

# Build production release
pnpm tauri build
```

### Frontend Only

```bash
# Start Vite dev server only (port 5005)
pnpm dev

# Build frontend only
pnpm build
```

### Linting

```bash
# Run ESLint (configured for TypeScript + React)
npx eslint .
```

## Architecture

### Frontend-Backend Communication

The project uses **tauri-specta** for type-safe command bindings:

- Commands are defined in `src-tauri/src/commands.rs` with `#[tauri::command]` and `#[specta::specta]` attributes
- Events are defined in `src-tauri/src/events.rs` and derive `Event` from tauri-specta
- TypeScript bindings are auto-generated to `src/bindings.ts` on debug builds

**Never manually edit `src/bindings.ts`** — it is auto-generated from Rust code.

### State Management

Three main stateful components are managed as Tauri state:

1. **Config** (`src-tauri/src/config.rs`): User settings (cookie, download directories, concurrency limits)
2. **ManhuaguiClient** (`src-tauri/src/manhuagui_client.rs`): HTTP client for API requests to manhuagui.com
3. **DownloadManager** (`src-tauri/src/download_manager.rs`): Manages concurrent downloads with semaphore-based rate limiting

### Download System

Downloads use a two-level concurrency control:

- **Chapter semaphore**: Controls how many chapters download simultaneously (`chapter_concurrency` in config)
- **Image semaphore**: Controls how many images download simultaneously within a chapter (`img_concurrency` in config)

Download progress is communicated via events (`DownloadEvent`, `DownloadTaskEvent`) to the frontend.

### HTML Parsing

The `manhuagui_client.rs` scrapes HTML responses using the `scraper` crate. Key parsing logic is in:
- `src-tauri/src/types/` - Type definitions with `from_html()` methods
- `src-tauri/src/decrypt.rs` - Decrypts image URLs from JavaScript-obfuscated data

### Browser Headers

To avoid 403 Forbidden errors from manhuagui.com, all HTTP requests include browser-like headers:
- `User-Agent`: Chrome 120.0 on Windows 10
- `Accept`: Standard browser Accept header
- `Accept-Language`: zh-CN,zh;q=0.9,en;q=0.8
- `Referer`: Dynamically set based on request path

See `manhuagui_client.rs` for the implementation.

### UI Features

- **Login Retry Button**: When `getUserProfile()` fails, a red "重试登录" button appears next to the login button. Clicking it retries using the existing cookie.
- **Favorite Page Refresh**: The 漫画收藏 page has a "刷新" button in the bottom-left corner that remains visible even during network errors.
- **Session-only Download List**: The download queue is stored in memory only (not persisted). Use 本地库存 to view downloaded comics.

### Project Structure

```
src/                      # Frontend (React + TypeScript)
  bindings.ts            # Auto-generated Tauri bindings (DO NOT EDIT)
  components/            # React components
  panes/                 # Main application views (Search, Favorite, Downloading, etc.)
  styles/                # CSS modules and global styles

src-tauri/src/           # Backend (Rust)
  commands.rs            # Tauri command handlers
  download_manager.rs    # Concurrent download management
  manhuagui_client.rs    # HTTP client for manhuagui.com
  types/                 # Data models and HTML parsing
  events.rs              # Event definitions for frontend communication
  config.rs              # Configuration management
```

## Branch Strategy

PRs should target the **`develop`** branch, not `main`.

## Version Bump

When updating the version:
1. Update `version` in `src-tauri/tauri.conf.json`
2. The Cargo.toml version is less important (kept at 0.1.0)

## Cross-Compilation Notes

For Windows builds from non-Windows hosts, the project uses `cargo-xwin`:
```bash
pnpm tauri build -- --runner cargo-xwin --target x86_64-pc-windows-msvc
```

## Styling

Uses **UnoCSS** for atomic CSS. See `uno.config.ts` for configuration. Common patterns:
- Flexbox: `flex`, `flex-col`, `items-center`, `justify-between`
- Spacing: `p-4`, `m-2`, `gap-3`
- Sizing: `w-full`, `h-32`
