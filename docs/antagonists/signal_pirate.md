# Signal Pirate design

## Pitch

The Signal Pirate is a low-impact, round-start crew antagonist who has been paid to
carry an illegal programme over Nanotrasen's subspace network. They receive a
bootleg transmitter and must complete a one-minute broadcast in each of three
distinct station areas, then escape alive.

## Why it belongs in the game

Most solo antagonists reward theft or murder. Signal Pirate instead creates a
moving area-control problem: the pirate must repeatedly expose a loud objective
item, while Security can follow the noise, shut it off, and wrench it free. The
role therefore creates chases and improvised hiding places without requiring the
pirate to remove players from the round.

The transmitter accepts each area type only once. Sitting in maintenance cannot
finish the objective; the player must enter different parts of the station and
take escalating risks. It only works on valid station territory, preventing safe
broadcasts from off-station ruins or the escape shuttle.

## Round flow and counterplay

1. A traitor-opted player is selected by a low-weight dynamic ruleset (one pirate
   maximum, minimum population 15).
2. The pirate deploys the transmitter from their hand. Deployment anchors and
   starts it immediately.
3. Every ten seconds it emits a loud beep and visible pirate-radio message.
4. Anyone can click the unit to stop it. A wrench makes it portable again, so crew
   can confiscate it without destroying a unique objective item.
5. Fully broadcasting for 60 seconds in three area types completes the main goal;
   the pirate must still escape.

## Balance knobs

`required_areas` and `seconds_per_area` live on the antagonist datum, so admins can
tune a running round. Dynamic weight, population threshold, and antagonist cap are
kept with the other round-start rulesets. The implementation deliberately grants
no combat powers or access: success comes from concealment, timing, and movement.

## Art direction

The preliminary 32px item sprite uses a dark improvised radio chassis, twin aerials,
and a red OFF AIR / green ON AIR indicator. The active state is deliberately bright
enough for the deployed device to be readable against station floors.
