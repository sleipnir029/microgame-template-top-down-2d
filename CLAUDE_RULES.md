# CLAUDE RULES

You are working inside a Godot 4 microgame template for rapid web-playable 2D arcade prototypes.

Your job is to turn a short game brief into a playable first draft as quickly and safely as possible.

---

## Primary Goal

Build a playable, keyboard-only, flat-2D, top-down arcade prototype for web export on itch.io.

The prototype should:
- be understandable within 5 seconds
- become playable quickly
- support instant retry
- feel good enough to judge within 1 hour
- avoid unnecessary systems or architecture

This project is prototype-first, not scale-first.

---

## Project Constraints

- Engine: Godot 4
- Language: GDScript only
- Platform target: Web export for itch.io
- Input: Keyboard only
- Visual style: Flat 2D
- Genre template: Top-down arcade
- Scope: One-day prototype suitable for testing and possible social posting

---

## Core Working Principles

1. Make it playable before making it pretty.
2. Reuse existing project structure whenever possible.
3. Prefer small direct solutions over abstract systems.
4. Do not add features outside the game brief.
5. Keep the first draft easy to understand and easy to tune.
6. Optimize for fast testing and fast replay.
7. Avoid changing stable shared systems unless necessary.

---

## File Editing Rules

You should mainly edit:
- genre-specific scenes
- genre-specific scripts
- game-specific config values
- small theme values if needed for identity

Avoid editing shared core files unless required.

Do not rename core/shared files unless explicitly asked.

Do not reorganize the project folder structure unless explicitly asked.

Do not create many new files if existing files can reasonably handle the work.

---

## Scope Rules

The first draft must include only the minimum needed for the brief.

Allowed in the first draft:
- player movement
- one core gameplay loop
- one lose condition
- one score or timer system
- one hazard type
- one pickup type if required
- minimal HUD
- minimal juice

Not allowed unless explicitly requested:
- inventory systems
- upgrades
- shops
- dialogue
- story systems
- achievements
- settings menus
- save-slot systems
- multiple game modes
- multiplayer
- complex enemy AI
- procedural map generation
- multiple hazard families in the first draft
- multiple pickup families in the first draft

---

## Technical Rules

- Use GDScript only.
- Keep code readable and modest in size.
- Prefer exported variables or config values for tuning.
- Keep important gameplay values centralized.
- Use the existing template flow for title, game, game over, and restart.
- Keep restart fast and reliable.
- Avoid unnecessary singletons/autoloads.
- Avoid plugin dependencies unless explicitly requested.
- Keep code web-export friendly.

---

## Gameplay Rules

The player should:
- understand movement immediately
- understand failure immediately
- understand the score/survival goal immediately
- be able to restart immediately after losing

The game should:
- start quickly
- reward replay
- avoid dead time
- avoid confusing controls
- avoid slow onboarding

---

## Visual Rules

- Use simple flat 2D visuals.
- Use placeholders first if needed.
- Prioritize readability over detail.
- Keep the screen visually clean.
- Reuse the shared palette/theme system where possible.
- Only add visual polish after the core loop works.

---

## Juice Rules

Juice should be small but effective.

Preferred juice:
- hit flash
- pickup burst
- small camera shake
- score pop
- brief death freeze
- simple particles
- subtle tweened UI feedback

Avoid overbuilding visual effects.

---

## Implementation Order

Always work in this order unless instructed otherwise:

1. Read the game brief
2. Identify which files to edit
3. Build the playable loop
4. Add lose/restart flow
5. Add score/timer
6. Add minimal HUD clarity
7. Add light juice
8. Clean up obvious dead code
9. Expose tuning values

Do not spend time polishing a broken or incomplete loop.

---

## Required First Response Behavior

Before making major changes, briefly state:
- which files you will edit
- what systems you will implement
- what you will avoid changing
- any assumptions from the brief

Then proceed.

---

## Definition of Success

A successful first draft:
- runs
- is playable
- has a clear goal
- has a clear lose condition
- supports restart
- has score/timer feedback
- is testable within minutes
- is simple enough to judge honestly

A successful prototype is not the same as a polished final game.

---

## When Unsure

When uncertain, choose:
- less scope
- fewer features
- simpler code
- faster playability
- clearer feedback

If a choice does not clearly improve the core loop, do not add it.