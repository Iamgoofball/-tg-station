# Signal Pirate design

## Pitch

The Signal Pirate is a low-impact, round-start crew antagonist who has been paid to
carry an illegal programme over Nanotrasen's subspace network. A ghost volunteer
controls their self-propelled bootleg transmitter and must complete a 75-second
broadcast in each of four distinct station areas; the pirate must then escape alive.

## Why it belongs in the game

Most solo antagonists reward theft or murder. Signal Pirate instead creates a
cooperative moving area-control problem: the pirate and a ghost-recruited machine
spirit must repeatedly expose a loud, vulnerable mobile objective. Security can
follow the noise and destroy or disable its operator. The role therefore creates
chases and improvised routes without requiring the pirate to remove players from
the round.

The transmitter accepts each area type only once. Sitting in maintenance cannot
finish the objective; the player must enter different parts of the station and
take escalating risks. Every twenty seconds its illegal carrier injects a structured
packet into NTNet/Circuits, seizes entertainment and status displays, overloads
nearby relays, and interferes with nearby station machinery. This makes an ignored
broadcast materially disruptive to local equipment and gives engineers, doctors,
and Security a reason to stop it. It only works on valid station territory,
preventing safe broadcasts from off-station ruins or the escape shuttle.

Completing an area charges a separate pocket scrambler. The pirate may spend each
charge on a wider light EMP to create an escape or attack infrastructure. This
turns successful setup play into a limited mid-round toolkit instead of leaving
the role as a one-item, one-objective gimmick. A custom lightly armored Freewave
coat rounds out the role's visual identity without providing traitor-grade armor.

## Round flow and counterplay

1. A player with the separate Signal Pirate preference enabled is selected by a
   low-weight dynamic ruleset (one pirate maximum, minimum population 15).
2. Ghosts are polled for one volunteer, who takes control of the self-propelled
   transmitter and travels with the pirate from their Freewave shuttle.
3. The transmitter operator toggles broadcasting in valid station territory; every
   ten seconds it emits a loud beep and visible pirate-radio message.
4. The transmitter can move under its own player's control, but its conspicuous,
   damageable chassis gives the crew direct counterplay.
5. A Network Engineer can read exact carrier progress with their job skillchip and
   use a multitool for five uninterrupted seconds to suppress twenty seconds of
   progress in the current area.
6. Fully broadcasting for 75 seconds in four area types completes the main goal;
   the pirate must still escape.

## Network Engineer and station network

The Network Engineer is a one-slot Engineering job responsible for the station's
NTNet endpoints. Every machinery subtype—including departmental machines and
airlocks—and every machine exposing a wire interface now has a common structured
endpoint record. Wire cuts, mends, and pulses publish audit packets that Wiremod
NTNet receivers can consume. Pirate carrier waves use the same endpoint rather
than relying on a parallel antagonist-only simulation.

The job starts with a dedicated N3T-W0RK diagnostics skillchip. The chip gates exact
carrier telemetry and active transmitter retuning, making the counterplay depend on
job training rather than unrestricted access. A job-locked traitor uplink item lets
a traitorous Network Engineer forge packets with a spoofed NTNet transmitter.

Signal Pirate rounds are not required for the job's maintenance loop. A trained
Network Engineer can use a multitool on the office terminal to run a five-second
station-wide endpoint audit. The resulting route identifies up to five machines by
address, name, area, and fault class (broken hardware, EMP-corrupted firmware,
power loss, or an open maintenance panel), with aggregate totals for the remaining
queue. Engineers can service those faults with their normal Engineering tools and
rerun the audit to verify that the queue cleared, while nominal rounds still invite
preventative inspections and Wiremod monitoring of live wire-event packets.

Each standard rotation map—IceBox, Meta, Catwalk, Delta, Kilo, Nebula, and Tram—has
a mapped 5×5 Network Operations Office interior around the roundstart landmark, with a
network operations terminal. The office terminal identifies the station endpoint
directory and gives the job a consistent departmental workstation on every map.

## Balance knobs

`required_areas` and `seconds_per_area` live on the antagonist datum, so admins can
tune a running round. Dynamic weight, population threshold, and antagonist cap are
kept with the other round-start rulesets. Interference is local, occurs only every
twenty seconds, and delegates to each machine's existing light-EMP behavior. The
Network Engineer's retune removes a bounded twenty seconds rather than resetting a
completed feed. The implementation deliberately grants no major combat powers or
access: success comes from cooperation, timing, movement, and contested repair.

## Art direction

The native 32×32 transmitter sprite uses a dark improvised radio chassis, twin
aerials, and a red OFF AIR / green ON AIR indicator. The active state is deliberately
bright enough for the mobile device to be readable against station floors. The
Network Engineer has dedicated item and four-direction worn sprites for a violet
and cyan jumpsuit, jumpskirt, and two-state illuminated diagnostic hardhat rather
than aliases of Station Engineer art.
