
Pages:

- Fader
- Tune
- Settings

Grid Zeros show two layers the same time

Need to find a better way to detect toggling layers on Grid One. Hold a track select button for 3 seconds?

## Feature Ideas

- Independent page display per fader?
  - Would need some way to synchronize everything together.

### Psets

Save/load pset controls

16 slots of psets, some button combo to save/load current settings with a 16 column slot select UI.

## Page Navigation

- Fader (Brightest)
- Tune (Middle)
- Settings (Pulse)

Hold track select bar to toggle the visible page.

On Grid Zero, the top and bottom panels are independent.

## Fader Page

Whatever button is held should be the target point of the slew, once pad is released, the slew should stop. Double tap middle, bottom, and top pads should instantaneously jump to middle, bottom, or top values.

Fader position is anti-aliased across 3 pads (top, middle, bottom) and 2 when the middle pad is at the end of the fader range.

## Tune Page

Button interaction should be more fun with slews
Each press should trigger a continuous slew at a fast, slow, or instant rate.

1 Set to Max
2 Large step increase by static amount
3 Small step increase by static amount
4 Set to middle
5 Small step decrease by static amount
6 Large step decrease by static amount
7 Set to Min

## Settings Page

Per fader settings

**Option 1 Simpler:**

1 set MIDI channel
2 set MIDI CC number
3 set MIDI CC value maximum
4 set MIDI CC value minimum
5 Toggle fader slew rate (static slow/medium/fast and dynamic)
6 ?
7 ?

**Option 2 Deeper Controls:**

Hold one of the first four pads to access its' submenu.

1 Set MIDI out 1
2 Set MIDI out 2
3 Set MIDI out 3
4 Set MIDI out 4
5 Toggle fader slew rate (static slow/medium/fast and dynamic)
6 ?
7 ?

MIDI out submenu:

1 set MIDI channel
2 set MIDI CC number
3 set MIDI CC value maximum
4 set MIDI CC value minimum
