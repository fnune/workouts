# Workouts repo guidelines

These rules apply to any workout in this repo. Equipment, schedule, and per-session conventions are declared in each `workouts/*.typ` file (see the `equipment` and `subtitle` fields). The cue voice and structural rules below hold regardless of what equipment a given workout uses.

## Cue voice
Technical, geometric, anatomical. Precision over plain language.

- Use angles ("90° from the anchor"), distances ("step back until taut"), heights ("anchor at chest height"), anatomical terms ("hip hinge", "neutral spine", "scapular retraction").
- Prefer the precise term when one exists: "90° from anchor" not "sideways", "hip hinge" not "bow forward", "thighs parallel to floor" not "go down".
- Short sentences, but precision wins over simplicity.

## Setup completeness
Every cue must let the user reconstruct the setup from the cue alone:

- Where each end of any implement attaches (anchor / surface / body part).
- Where the body is positioned (orientation, angle to anchor, foot/hand placement).
- The movement itself.

A cue missing any of these is unusable mid-workout. Refer only to equipment listed in that workout's `equipment` field.

## Equipment-imposed slack
When the equipment leaves more length/range than the working span requires (e.g. a band longer than arm-span on a pull-apart), the cue must explicitly resolve the slack with a concrete mechanical instruction ("wrap once around each wrist", "step on the middle"). No jargon ("choke up", "shorten the lever"); say the physical action.

## Formatting
- No em dashes (—). En dashes (–) only inside numeric ranges like `10–12`.
- Sentence case only; no title case in headings.
- No bold for emphasis.
- No acronyms. Always expand: "bodyweight" not "BW", "Romanian Deadlift" not "RDL", "max reps − 2" not "AMRAP-2", "reps in reserve" not "RIR". Standard words like "rep" (repetition) are fine; opaque initialisms are not.

## Workout file structure
Each `workouts/<name>.typ` declares:

- `title`: short name of the session.
- `subtitle`: schedule / intensity / duration context.
- `equipment`: comma- or `·`-separated list of what the user has out for this session.
- `#warmup[...]`: one-line stretch list.
- One `#exercise(name, sets, cue)` per move.

The exercise `name` is slugified to look up `images/<slug>.jpg`; add a new `mappings.toml` entry to fetch a new image.

## Build
`nix develop` enters the dev shell (typst, curl, jq, imagemagick).

- `scripts/search.sh <term>`: look up an exercise id in the free-exercise-db.
- `scripts/fetch.sh`: download images per `mappings.toml`, post-process (desaturate, sigmoidal contrast, blur-pad to 850×567).
- `scripts/build.sh`: compile `workouts/*.typ` to `dist/*.pdf`.

New workout: copy a file under `workouts/`, edit fields, add any new mapping in `mappings.toml`, then `scripts/fetch.sh && scripts/build.sh`.
