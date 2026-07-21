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
take escalating risks. Every twenty seconds its illegal carrier causes a light EMP
in the immediate vicinity. This makes an ignored broadcast materially disruptive
to local equipment and gives engineers, doctors, and Security a reason to stop it.
It only works on valid station territory, preventing safe broadcasts from
off-station ruins or the escape shuttle.

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
5. Fully broadcasting for 75 seconds in four area types completes the main goal;
   the pirate must still escape.

## Balance knobs

`required_areas` and `seconds_per_area` live on the antagonist datum, so admins can
tune a running round. Dynamic weight, population threshold, and antagonist cap are
kept with the other round-start rulesets. The implementation deliberately grants
no major combat powers or access: success comes from cooperation, timing, and movement.

## Art direction

The 128px transmitter sprite uses a dark improvised radio chassis, twin aerials,
and a red OFF AIR / green ON AIR indicator. The active state is deliberately bright
enough for the mobile device to be readable against station floors.
