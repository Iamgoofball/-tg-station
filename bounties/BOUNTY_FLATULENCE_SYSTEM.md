# 📌 BOUNTY: Flatulence System — Design Document

## Overview

Implementation of a comprehensive flatulence system for /tg/station, bringing
back a staple feature from the legendary downstream HippieStation. This system
integrates seamlessly with existing medical and organ frameworks.

---

## 1. Core Components

### 1.1 Butt Organ (`/obj/item/organ/butt`)

A new internal organ located in the groin region.

| Property | Value |
|----------|-------|
| Zone | `BODY_ZONE_PRECISE_GROIN` |
| Slot | `ORGAN_SLOT_BUTT` |
| Max Health | `STANDARD_ORGAN_THRESHOLD` |
| Healing Factor | `STANDARD_ORGAN_HEALING` |
| Decay Factor | `STANDARD_ORGAN_DECAY` |

**Surgical Integration:**
- Butt organ can be added/removed via standard organ manipulation surgery
- Uses existing surgery tools and procedures
- Appears on medical scanners
- Can be augmented (cybernetic butt pending)

### 1.2 Fart Verb

- **Command:** `*fart` or verb "Fart"
- **Effect:** Plays a randomized toot sound effect (3 variants)
- **Cooldown:** 15 seconds (configurable)
- **Requirement:** Must have a functional butt organ
- **Social:** Visible to nearby mobs within 3 tile radius
- **Medical:** Slight stamina drain (2-5 points)

### 1.3 Super Fart

- **Command:** `*superfart` or verb "Super Fart"
- **Effect:** 
  - Massive sound effect
  - Small explosion (1 tile radius, light damage)
  - Knockback to nearby mobs
  - Releases methane gas cloud (3x3 area)
- **Cost:** Destroys the user's butt organ on use
- **Cooldown:** Once per butt (requires surgical replacement)
- **Warning:** 5 second charge-up with visible/audible cues

### 1.4 Gameplay Loop Integration

```
[Player has Butt?] ──No──▶ [Cannot fart]
       │
      Yes
       │
       ▼
[Regular Fart] ◀── Wait 15s ──▶ [Regular Fart]
       │
       │ (player chooses)
       ▼
[Super Fart] ──▶ [Butt destroyed] ──▶ [Seek surgery for new butt]
                                         │
                                         ▼
                                   [Medical/Surgery loop]
```

---

## 2. Medical System Integration

- Butt organ damage tracked via standard organ damage system
- Butt failure causes inability to fart (regular OR super)
- Inflamed butt causes involuntary farts at random intervals
- Butt may become inflamed from:
  - Eating spicy foods
  - Certain diseases
  - Random chance (similar to appendicitis)

---

## 3. Technical Architecture

```
code/modules/flatulence/
  ├── _fart_verb.dm       ← Fart/superfart verb definitions
  └── _fart_effects.dm    ← Gas cloud, explosion, SFX hooks

code/modules/surgery/organs/internal/butt/
  └── _butt.dm            ← Butt organ definition (Egyptian documented)
```

---

## 4. Dependencies

- Existing organ framework (`/obj/item/organ`)
- Medical surgery system (`code/modules/surgery/`)
- Bodypart system (`code/modules/surgery/bodyparts/`)
- Atmospherics (for methane gas release)
- Sound system (for SFX)

---

## 5. Future Enhancements

- Cybernetic butt (reusable super fart, EMP vulnerability)
- Fart-based propulsion in zero-gravity
- Butt augmentation pills
- Fart alchemy (chemical reactions from consumed reagents)

---

*Design Doc v1.0 — Prepared for Bounty #233*
*"He who hath no butt, hath no toot." — Ancient SS13 Proverb*
