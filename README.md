# STARS 2023 Design Final Project

## Silly Synth Specialists (Triple SSS)
* Austin Bohlmann
* Ethan Christie
* Adam Mack
* Andre Ponsot
* Noah Rediker

## Silly Synthesizer
A synthesizer with the following specifications:
- Thirteen note buttons to play an entire octave from C to C
- A note range from C2 to C7
- Two octave buttons to raise or lower the octave being played
- One button to change the shape of the wave between off, triangle, sawtooth, and square modes
- One button to goof-off.
- Clock speed of 10MHz
- Supply Voltage of 3.3V

## Pin Layout
Input: GPIO [0:12] keyboard (C, C#, D ... A#, B, C), [13] mode key, [14:15] octave change (down, up), [16] goof-off

Output: GPIO [33] PWM

## Supporting Equipment
To properly output audio, the synthesizer utilizes an audio amplifier as shown below. It requires 12V supply and uses an LM386 (shown as LM393 in diagram) op amp integrated circuit to amplify the analog wave output of the synthesizer device.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/0efa8909-6f69-4a53-ba52-790169fb69c4)

## RTL Diagrams
Top level Diagram:
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/16dde41c-7434-43e2-b67a-d8375bee60e8)
Sound Driver RTL. This section creates and outputs the sound wave based on which button is being pressed.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/5589a585-2c8c-4dde-8b05-ae14064616e7)
Clock Divider RTL Diagram, supplying a 4Hz signal to the RNG block and a 49kHz signal to the wave shaper.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/0e67146f-2e5a-4e12-bc50-1351ebaae38a)
Pulse Width Modulator, controlling the output based on the calculations performed by the wave shaper.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/2567be32-cb15-4693-aff4-5b884a3fa278)
Oscillator, which counts from 1 to the divisor value given from the lookup table.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/49051a83-e357-4890-a78d-d35beea7d4c5)
Wave Shaper Module Diagram. This module uses a sequential divider to divide the oscillator's output by the lookup frequency of the note played, then performs combinational logic to output a wave.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/30892add-0047-450b-ac22-7e0783530729)
Sequential Divider Diagram as a submodule of the wave shaper.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/db03872c-c201-4bc4-8e9f-276c669f099f)
Random Number Generator Module, which is applied to the goof-off button.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/8a42f75f-ce00-43ae-9dbe-030147ee235a)
Linear Feedback Shift Register (LFSR) as part of the RNG module.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/66220465-27fc-45c0-80b2-7c3b22742484)
Input Modules, which outputs the correct frequency to play based on the note pressed, normal or goof-off mode, and the selected octave.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/e375f8d8-2dcc-4fd2-ad6c-9c9975f2851f)
Keypad Encoder Module:
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/05912619-463b-4d02-a224-537e9015b346)
Wavetype State Diagram to determine which wave shape the device outputs.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/208625a8-acf6-4433-84db-0789ab2ba3b4)
Octave State Diagram to determine what octaves the keyboard corresponds to.
![image](https://github.com/STARS-Design-Track-2023/silly-synthesizer/assets/111792941/6879c317-c5a7-4310-92ae-d4c653e7b21d)



## Statement from Purdue
Pending

Peace and love to hall from the Silly Synthesizer Specialists <3
