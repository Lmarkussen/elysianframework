# Elysian Framework (WoW: Midnight) - Codex

## Goal
Build a World of Warcraft addon for the Midnight expansion. Initial milestone: draw a small menu window and theme the default Game Menu (Escape menu) using Dracula colors.

## Status (2026-02-20)
- Added base addon files and initial Lua with a themed window titled "Elysian Framework".
- Applied Dracula colors (from local Ghostty config) to the custom window and the default Game Menu frame.
- Expanded the frame to include a left navigation and a "Scrap Seller" toggle panel.
- Added a basic auto-sell handler for gray-quality items when a merchant opens and the toggle is enabled.
- Refactored the addon into modules and added a Fonts/Assets/Sounds folder structure.
- Added `/elysianframe` slash command to toggle the main menu.
- Added Hack regular font (from `Hack.zip`) and applied it to custom UI text.

## Current Behavior
- On login, a centered frame appears with the title text and left navigation.
- Opening the Game Menu (Escape) recolors its backdrop and header text/texture when possible.
- The main frame is draggable.
- The "Scrap Seller" toggle enables auto-selling gray-quality items on merchant open.
- `/elysianframe` toggles the main frame visibility.
- The "Do not show at start" checkbox (bottom-left) controls auto-show behavior.
- Tabs are styled as square buttons with a darker Dracula shade and selected-state highlight.
- Added a "Cursor Ring" tab with controls for enable, size, and color.
- Added a panel color picker for the content area under the tab menu.
 - Cursor ring uses `Assets/cursor_ring.tga` for a consistent ring texture.

## Local Test Path
- Retail AddOns folder: `/home/lars/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns`
- Addon deployed to: `/home/lars/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_retail_/Interface/AddOns/ElysianFramework`
- Deploy script: `scripts/deploy.sh` (rsyncs addon to Retail AddOns folder)

## Notes / Research Reminders
- Midnight is the second expansion in the Worldsoul Saga, following The War Within and preceding The Last Titan. It was announced at BlizzCon 2023; keep an eye on official Blizzard updates for any API changes or timeline updates.
- WoW addons require a `.toc` file with an `## Interface` number matching the client build. Verify with `/dump select(4, GetBuildInfo())` in-game and update `ElysianFramework.toc` accordingly.

## Next Steps
- Decide whether to persist the Scrap Seller toggle between sessions via SavedVariables.
- Expand theming to other UI elements if desired.

## Recent Updates
- Version: v0.00.12.
- Cursor trail only renders while the mouse is moving.
- Snapshot created: ElysianFramework_0.00.12.zip.
- Cursor trail now fades out on idle and clears on stop so it doesn't pick up old positions.
- Added a trail shape dropdown (spark/ring/thin/star/square/crosshair).
- Version: v0.00.13.
- Added Warlock alert text color pickers (pet missing + healthstone).
- Snapshot created: ElysianFramework_0.00.13.zip.
- Version: v0.00.14.
- Snapshot created: ElysianFramework_0.00.14.zip (older snapshots removed).
- Version: v0.00.15.
- Snapshot created: ElysianFramework_0.00.15.zip.
- Version: v0.00.16.
- Snapshot created: ElysianFramework_0.00.16.zip (older snapshots removed).
- Profiles added (per character) with Default profile, save/load in General tab.
