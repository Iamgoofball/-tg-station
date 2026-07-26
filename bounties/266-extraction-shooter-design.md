# -TG-STATION EXTRACTION SHOOTER GAMEMODE

## Design Document — "BREACH & EXTRACT"

---

## 1. EXECUTIVE OVERVIEW

### 1.1 Vision Statement
BREACH & EXTRACT transforms /tg/station into a high-stakes extraction shooter where squads deploy onto derelict stations, abandoned research facilities, and hostile outposts. Players must fight through PvE threats (xenomorphs, syndicate remnants, rogue AI drones) and rival player squads to secure valuable objectives, then reach an extraction point before the zone collapses or reinforcements arrive.

### 1.2 Core Loop
```
DEPLOY → INFILTRATE → LOOT/OBJECTIVE → SURVIVE → EXTRACT → UPGRADE → REPEAT
```

### 1.3 Design Pillars
1. **Gear Fear**: Losing your loadout on death creates real stakes
2. **Squad Synergy**: Roles matter — medic, breacher, scout, heavy
3. **Dynamic Threats**: PvE threats scale with time-in-zone and loot value carried
4. **Map Knowledge**: Learn spawn points, loot rooms, extraction zones across multiple maps
5. **Progression**: Persistent stash, trader unlocks, faction reputation

---

## 2. GAMEMODE ARCHITECTURE

### 2.1 Round Structure

| Phase | Duration | Description |
|-------|----------|-------------|
| **PREP** | 3 min | Squad assembly, loadout selection, briefing |
| **INFIL** | 0-5 min | Pod drop / shuttle breach into the zone |
| **OPERATION** | 15-25 min | Free-roam objective completion |
| **EXTRACTION WINDOW** | 3 min | Extraction points activate |
| **EMERGENCY EXFIL** | 2 min | Final chance extraction, high risk |
| **DEBRIEF** | 2 min | Score tally, loot transfer, XP allocation |

### 2.2 Player Count
- **Minimum**: 4 players (1 squad vs environment)
- **Optimal**: 12-20 players (3-5 squads of 4)
- **Maximum**: 32 players (8 squads of 4)
- **Solo/Duo Queue**: Fill slots with volunteer crew or AI companions

### 2.3 Squad Composition (4 Players)
| Role | Primary Task | Unique Equipment |
|------|-------------|------------------|
| **Pointman** | Frontline combat, breaching | Breaching charge, combat shotgun |
| **Specialist** | Heavy weapons, suppression | LMG, deployable shield |
| **Technician** | Hacking, traps, intel | Multitool+, sensor array, turret kit |
| **Corpsman** | Healing, revival, buffs | Medkit+, defibrillator, stim dispenser |

---

## 3. MAPS & ENVIRONMENTS

### 3.1 Launch Maps

#### MAP 1: DERELICT STATION "ICARUS"
- Abandoned NT research station, 5 years derelict
- **Threats**: Xenomorph infestation (drone caste), malfunctioning secbots
- **Loot Focus**: Research data, prototype weapons, rare materials
- **Extraction Points**: 2 primary (shuttle docks), 1 emergency (escape pod bay)
- **Special Feature**: Gravity failures in damaged sections — magboots required

#### MAP 2: SYNDICATE OUTPOST "HADES"
- Captured Syndicate blacksite on a volcanic moon
- **Threats**: Syndicate remnant forces, automated turrets, lava hazards
- **Loot Focus**: Syndicate tech, encryption keys, black market items
- **Extraction Points**: Landing pad (hot), cave system (safer but longer)
- **Special Feature**: Volcanic eruptions periodically flood low ground with lava

#### MAP 3: CARGO DEPOT "NEXUS"
- Abandoned interstellar cargo hub
- **Threats**: Pirate scavengers, cargo mechs gone haywire
- **Loot Focus**: Trade goods, ship parts, exotic minerals
- **Extraction Points**: Cargo elevator, roof helipad
- **Special Feature**: Movable cargo containers create dynamic cover

### 3.2 Map Design Philosophy
- **Verticality**: Multi-level maps with ladders, vents, and elevator shafts
- **Chokepoints**: 3-4 natural chokepoints per map that squads must navigate
- **Rotating Extraction**: Extraction points change each round (3 possible, 2 active)
- **Dynamic Lighting**: Power can be restored to light up dark sections (alerts enemies)
- **Environmental Hazards**: Gas leaks, fire, radiation zones, vacuum breaches

---

## 4. WEAPON ECOSYSTEM

### 4.1 Weapon Tiers

| Tier | Rarity | Examples | Acquisition |
|------|--------|----------|-------------|
| **Common** | White | Crowbar, pipe rifle, zip gun | Default loadout, ground loot |
| **Uncommon** | Green | WT-550, C-20r SMG, double-barrel | Ground loot, low-tier trader |
| **Rare** | Blue | Laser rifle, Bulldog shotgun, RPG | High-value rooms, bosses |
| **Legendary** | Purple | X-01 Multiphase, L6 SAW, ion rifle | Vault rooms, extract streaks |
| **Exotic** | Gold | Alien blaster, Syndicate hardsuit weapon | Special events, faction rewards |

### 4.2 New Extraction-Specific Weapons

**Breaching Shotgun "Door-Kicker"**
- Short barrel, wide spread, 4-round magazine
- Special ammo: Breaching slug (destroys doors in 1 hit), Dragon's breath (area denial)
- Cannot be suppressed — firing it alerts the entire POI

**Tactical Crossbow "Whisper"**
- Silent, retrievable bolts
- Ammo types: Tranquilizer (puts mobs to sleep), Explosive (delayed 3s), Tracker (pings target)
- Low damage, high utility

**Mag-Harness "Pitbull"**
- Wrist-mounted magnetic launcher
- Fires scrap metal, tools, and grenades at high velocity
- Infinite ammo (uses environment debris) but slow fire rate

**Syndicate Prototype "Phantom"**
- Cloaking device that works while holstered (takes 2s to decloak)
- Fires armor-piercing flechettes
- Battery-powered, recharges slowly

### 4.3 Weapon Modding System
- **Barrel**: Silencer (quieter), Compensator (less recoil), Extended (more damage)
- **Sight**: Red dot (faster ADS), Scope (zoom), Thermal (see through walls, limited battery)
- **Underbarrel**: Grenade launcher, flashlight, laser sight (hipfire accuracy)
- **Magazine**: Extended, quick-reload, special ammo types
- **Stock**: Folding (faster swap), Precision (less sway), Shock-absorbing (fire on move)

---

## 5. ENEMIES (PvE)

### 5.1 Threat Categories

**Xenomorph Types (Icarus Map)**
- **Drone**: Melee, fast, weak — swarms of 5-10
- **Warrior**: Armored, charge attack, grapples — 2-3 per squad encounter
- **Praetorian**: Ranged acid spit, calls reinforcements — mini-boss
- **Queen**: Stationary boss, spawns drones, massive HP — map objective

**Syndicate Remnants (Hades Map)**
- **Operative**: Standard enemy, uses cover, callouts
- **Heavy**: Energy shield, slow, devastating at close range
- **Sniper**: Rooftop positions, laser sight visible, one-shot threat
- **Commander**: Buffs nearby enemies, drops keycard

**Automated Threats (All Maps)**
- **Secbot**: Patrols, stuns then beats — hackable by Technician
- **ED-209**: Heavy bot, step on you, machine gun — requires explosives
- **Turret**: Stationary, 180° sweep, laser-targeted — shoot the power cable
- **Drone Swarm**: Repair bots gone rogue — EMP grenade effective

### 5.2 AI Behavior Philosophy
- **Reactive, Not Scripted**: Enemies respond to gunfire, explosions, and dead allies
- **Territorial**: Enemies have patrol zones but will chase for limited distance
- **Escalation**: Killing enemies attracts more/harder enemies over time
- **Loot-Guarding**: Best loot rooms have the strongest guards

---

## 6. EXTRACTION MECHANICS

### 6.1 Extraction Points
- **Primary Extract (x2)**: Shuttle landing pads — loud, visible to all squads
- **Emergency Extract (x1)**: Escape pod / maintenance shaft — cramped, dangerous
- **Special Extract (conditional)**: Requires Technician to hack; silent extraction

### 6.2 Extraction Sequence
1. Squad reaches extraction zone
2. Call extraction shuttle (30-60 second timer, loud alarm)
3. Defend position against PvE swarms drawn by the noise
4. Shuttle arrives, boarding ramp opens
5. 15 seconds to board — missed window = extraction fails
6. Shuttle departs, squad safe

### 6.3 Risk/Reward Extraction
- **Early Extract (first 10 min)**: Safe, low PvE, but minimal loot
- **Mid Extract (10-20 min)**: Moderate risk, standard loot
- **Late Extract (20-25 min)**: High PvE, max loot density, other squads likely nearby
- **Emergency Exfil (25+ min)**: Zone collapse begins, all enemies enraged, 50% loot penalty

---

## 7. ECONOMY & PROGRESSION

### 7.1 Loot Categories

| Category | Examples | Value | Stack Size |
|----------|----------|-------|------------|
| **Intel** | Research data, security logs, Syndicate codes | High | 1 |
| **Materials** | Plasma, diamond, bluespace crystals | Variable | 10 |
| **Weapons** | Guns, melee, explosives | High | 1 (backpack) |
| **Gear** | Armor, tools, meds | Medium | Varies |
| **Artifacts** | Unique quest items, alien tech | Very High | 1 |
| **Scrap** | Broken parts, wiring, metal sheets | Low | 20 |

### 7.2 Persistent Stash (Between Rounds)
- Each player has a **personal stash** (expandable via upgrades)
- Items extracted go to stash automatically
- Loadout is assembled from stash before each deployment
- **Stash Insurance**: Pay credits to insure 1-3 items (returned if you die)
- **Stash Size**: Starts at 10 slots, upgradeable to 50

### 7.3 Trader System
- Between rounds, visit the **Black Market Hub**
- Three rotating traders with different specialties:
  - **Arms Dealer**: Weapons, ammo, mods
  - **Techmonger**: Gadgets, hacks, drones
  - **Sawbones**: Meds, stims, augments
- **Reputation**: Higher rep = better prices and rare stock
- **Barter**: Trade items directly for other items

### 7.4 Faction Reputation
- **Nanotrasen Security**: Better starting gear, access to restricted areas
- **Syndicate**: Black market access, sabotage missions
- **Free Traders**: Better sell prices, smuggler routes
- **Xenobiologists**: Alien tech research, bio-weapons

---

## 8. SQUAD COMMUNICATION & PING SYSTEM

### 8.1 Communication Channels
- **Squad Radio**: Voice + text, squad only
- **Proximity Voice**: Enemies can hear you if close
- **Command Channel**: Squad leaders coordinate multi-squad ops

### 8.2 Ping System (SS13-Adapted)
- **Single Click**: "Look here" — general attention ping
- **Double Click**: "Danger!" — red alert ping
- **Hold Click**: Radial menu → "Loot Here", "Defend", "Breach", "Heal"
- **Enemy Ping**: Click on enemy to mark them (lasts 5 seconds)
- **Object Ping**: Click on item to highlight for squad

---

## 9. GODOT-TO-BYOND COMPATIBILITY LAYER

### 9.1 Rationale
Rather than running a full Godot engine inside BYOND, we implement a **rendering bridge**:
- Godot handles: 3D weapon viewmodels, particle effects, dynamic lighting, post-processing
- BYOND handles: Game logic, networking, player state, inventory

### 9.2 Technical Architecture
```
BYOND Server (DM) ←→ DreamDaemon Bridge ←→ Godot Client (GDScript)
         ↕                                         ↕
   Game State                                 Visual Layer
   (Logic, Net, DB)                          (3D, FX, UI)
```

### 9.3 Communication Protocol
- **WebSocket bridge**: Bidirectional JSON messages between DM and Godot
- **State Sync**: Player position, health, inventory, and environment state
- **Event System**: Shots fired, explosions, door states, extraction events
- **Render Commands**: DM sends "play_fx explosion at (x,y,z)" → Godot renders

### 9.4 Implementation Phases
1. **Phase 1**: Basic WebSocket bridge, position sync, static 3D view
2. **Phase 2**: Weapon viewmodels, first-person perspective
3. **Phase 3**: Particle effects, dynamic lighting, post-processing
4. **Phase 4**: Full environment rendering from DM map data

---

## 10. SOUNDTRACK DESIGN BRIEF

### 10.1 Audio Layers
1. **Ambient Layer**: Station hums, distant explosions, alien screeches — dynamic based on location
2. **Tension Layer**: Music intensity scales with nearby threats and time in zone
3. **Combat Layer**: Triggers on engagement — pounding industrial/dark synth
4. **Extraction Layer**: Euphoric, high-energy — the relief of survival

### 10.2 Track List Concepts
| Track | Context | Style Reference |
|-------|---------|-----------------|
| "Breach Protocol" | Deployment/infiltration | Dark synthwave, low BPM |
| "Hostile Acquisition" | Combat (PvE) | Industrial metal, driving beat |
| "Hunter Becomes Hunted" | Combat (PvP) | Tense electronic, heartbeat bass |
| "The Prize" | Loot room discovery | Ambient, wondrous |
| "Clock's Ticking" | Extraction countdown | Fast synth, building intensity |
| "Safe Harbor" | Successful extraction | Release, melodic resolution |
| "No Man Left" | Squad wipe | Somber, minimalist |

---

## 11. INTEGRATION WITH EXISTING SS13 SYSTEMS

### 11.1 Shared Systems
- **Health/Damage**: Same limb-based damage system, surgery, organ damage
- **Atmospherics**: Gas hazards, pressure, temperature — same sim
- **Power**: Restore power to open locked areas, disable turrets
- **Chemistry**: Same chem system — craft stims, explosives, healing

### 11.2 New Systems
- **Squad HUD**: Squad health, ammo, objective markers (TGUI)
- **Stash Interface**: Persistent inventory between rounds (TGUI + database)
- **Trader UI**: Buy/sell/barter interface (TGUI)
- **Loadout Builder**: Drag-and-drop gear onto character (TGUI)

### 11.3 Round Transition
- Between extraction rounds, the main station operates normally
- Players can craft, trade, socialize on-station
- Extraction missions are launched from a dedicated "Mission Control" area
- Crew rotations: Play extraction shooter, then play regular station roles

---

## 12. BALANCE & FAIRNESS

### 12.1 Gear Score Matchmaking
- Each loadout has a **gear score** based on item tiers
- Squads matched against similar gear score ±15%
- Prevents fresh spawns from fighting legendary-equipped veterans

### 12.2 Death & Recovery
- **Squad Wipe**: All items lost (except insured items + secure container)
- **Individual Death**: Squad can recover your body and extract your gear
- **Secure Container**: 2-slot container, items inside always survive
- **Scav Runs**: Free basic loadout, no risk, keep what you extract

### 12.3 Anti-Griefing
- Friendly fire disabled for squads (configurable)
- Extraction camping: Shuttles have automated defense turrets
- Spawn rushing: Randomized spawn points, minimum distance from other squads

---

## 13. DEVELOPMENT ROADMAP

### Phase 1: Foundation (Month 1-2)
- [ ] Gamemode framework (round start/end, squad assignment)
- [ ] Map 1: Derelict Station basic layout
- [ ] 5 weapons (3 common, 2 uncommon)
- [ ] Basic PvE enemies (xeno drone, secbot)
- [ ] Single extraction point
- [ ] Squad HUD UI

### Phase 2: Core Loop (Month 2-3)
- [ ] Persistent stash system
- [ ] Trader (T1 items only)
- [ ] Weapon modding (barrel + sight)
- [ ] Map 2: Syndicate Outpost
- [ ] Additional PvE types (warrior, heavy, turret)
- [ ] Multi-extraction points
- [ ] Ping system

### Phase 3: Depth (Month 3-4)
- [ ] Faction reputation system
- [ ] Godot integration Phase 1 (basic 3D)
- [ ] Map 3: Cargo Depot
- [ ] Boss enemies (Queen, Commander)
- [ ] Dynamic events (lava flood, gravity failure)
- [ ] Soundtrack implementation

### Phase 4: Polish (Month 4-6)
- [ ] Godot integration Phase 2-4
- [ ] Full weapon catalog (20+ weapons)
- [ ] Balance pass on all systems
- [ ] Tutorial/training mission
- [ ] Performance optimization

---

## 14. CONCEPT IMAGE DESCRIPTIONS

### 14.1 Squad Deployment
A 4-player squad stands in the deployment bay: Pointman with breaching shotgun checking door charges; Specialist kneeling with bipod-deployed LMG; Technician at a terminal bypassing security; Corpsman prepping stim injectors. Red emergency lighting casts long shadows. The mission timer reads 2:47.

### 14.2 Derelict Corridor Ambush
Dark maintenance corridor. Emergency lights flicker. In the darkness, 6 pairs of xenomorph eyes glow. The Pointman's flashlight catches a drone mid-pounce. Shell casings float in zero-G where the gravity generator failed.

### 14.3 Extraction Under Fire
The extraction shuttle ramp is down. Two squad members lay down suppressive fire as the Corpsman drags a wounded Technician up the ramp. Tracer fire crisscrosses the landing pad. The shuttle engines are spooling up — 8 seconds until departure.

### 14.4 The Stash
Between missions: a personal armory wall showing extracted weapons on magnetic racks. Trophy items from successful raids. The player's secure container sits open, showing a lucky artifact from the last run.

---

*Design Document v1.0 — Prepared for Bounty #266*
*Ready for review and concept iteration*
