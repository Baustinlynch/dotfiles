# Assembly

All PCB parts can be assembled by JLCPCB PCBA, but I have also selected parts that are relatively easy to solder by hand using a hotplate and soldering iron.

## 18650 version

### Parts

- One fully assembled board
- One 18650 battery
- 3D printed case parts
  - These should be fine printed in PLA, but a higher-temperature filament may be better as some switching regulators can produce more heat that PLA may not handle.
- 4 M3 threaded inserts (full dimensions will be picked later; I haven't finished modeling it yet)
- 4 M3 by 8mm machine screws 

### Tools
- lil screwdriver for the wire terminal
- flush cutters and wire strippers for separating out the wires for the string lights from the battery holder
- if you want, a command strip for wall mounting 

### Assembling

1. insert the threaded inserts into the holes on the bottom of the base piece of the enclosure
2. place the PCB into the base of the enclosure and connect it to the base by using the M3 bolts and screwing them through the holes in the PCB into the threaded inserts in the base
3. insert the 18650 battery into the battery carrier on the board
4. place the reset button pin into the top plate of the enclosure 
5. attach the top of the enclosure to the base, then attach it via the (not been fully designed yet so i like dont know how it will be attached)
6. Charge and program the board
  1. plug the board in via usb-c to any PD or 5v supply
  2. once charged, program the board with your code using the ESPHome web flasher 
7. cut the wires of the string lights that connect to the battery holder
8. strip the wires of the string lights, by about 1 or 2 mm 
9. insert the ends of the wires into the wire terminals and use your lil screw driver to tighten them down
  - make sure that you get the polarity of the wires correct, according to the embossed polarity symbols on the top of the enclosure

## JST version

### Parts

- One fully assembled board
- One jst battery
- 3D printed case parts
  - These should be fine printed in PLA, but a higher-temperature filament may be better as some switching regulators can produce more heat that PLA may not handle.
- 3 M3 threaded inserts (full dimensions will be picked later; I haven't finished modeling it yet)
- 3 M3 by 8 mm machine screws  
- a non-thermal, removable adhesive for mounting the battery in the enclosure (not strictly required)

### Tools
- lil screwdriver for the wire terminal
- flush cutters and wire strippers for seperating out the wires for the string lights from the battery holder 
- if you want, a command strip for wall mounting 

### Assembling
1. insert the 3 threaded inserts into the holes in the base of the enclosure
2. place the battery into the base of the enclosure and, if you want, use a light adhesive to attach it into its place. 
3. place the PCB into the base of the enclosure
4. place the top of the enclosure onto the base, pinning the PCB between the 2 parts
5. use the M3 machine screws to attach the base and top of the enclosure together
6. Charge and program the board
  1. plug the board in via usb-c to any PD or 5v supply
  2. once charged, program the board with your code using the ESPHome web flasher 
7. cut the wires of the string lights from the battery holder
8. strip back the insulation on the battery holder by about 1-2mm
9. insert the wires from the string light into the wire terminals and screw them into place
  - make sure that you get the polarity of the wires right !!
