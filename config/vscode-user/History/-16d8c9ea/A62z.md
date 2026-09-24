# Journal

## 8/5/26

- Found the ESP-32 MCU i want to use ([ESPRESSIF ESP32-S3-WROOM-1-N8](https://www.lcsc.com/product-detail/C2913198.html?s_z=n_q_esp32-S3%2520wroom&spm=wm.fly.bg.0.xh&lcsc_vid=RAALBlxfRVNXA1xQFAVeUlQHEgMNX1dfRlReAwIAQVExVlNRT1NbUlNfRVVaUTsOAxUeFF5JWBYZEEoKFBINSQcJGk4dAgUUFAk%3D))
- [Found 18650 battery mount tray](https://www.lcsc.com/product-detail/C2988620.html?s_z=n_q_18650%2520battery%2520holder&spm=wm.fly.bg.0.cbh&lcsc_vid=RAALBlxfRVNXA1xQFAVeUlQHEgMNX1dfRlReAwIAQVExVlNRT1NbUFRWQVVeVjsOAxUeFF5JWBYZEEoKFBINSQcJGk4%3D)
- Got the [USB-C Port](https://www.lcsc.com/product-detail/C2689970.html?s_z=n_q_C2689970&globalKeyword=C2689970)
- Got the [PD sink from a previous project](https://www.lcsc.com/product-detail/C22373734.html?s_z=n_q_C22373734&globalKeyword=C22373734)
- Find the Battery charger ic i want to use ([the TP4056](https://www.lcsc.com/product-detail/C16581.html?s_z=n_q_TP4056&spm=wm.fly.bg.0.xh&lcsc_vid=RAALBlxfRVNXA1xQFAVeUlQHEgMNX1dfRlReAwIAQVExVlNRT1NYV1VXQFRZVDsOAxUeFF5JWBYZEEoKFBINSQcJGk4NBhADEA4cHktXR1FaSQwSGg0%3D))
  - Spent a while setting the battery charging circut up

- Started the Layout and routing on the PCB

<https://lapse.hackclub.com/timelapse/oYXOqTZ7uB9a>

## 9/5/26

- did a bit more routing and declared some parts

## 27/5/26

- found the BMS ic i want to use [on LCSC](https://www.lcsc.com/product-detail/C351410.html)
- also found a better data sheet from [Digikey](https://www.digikey.co.uk/en/products/detail/shenzhen-slkormicro-semicon-co-ltd/DW01A/28143000) because the one on LCSC was a bit too vague
- finished the 3.7v battery system schematic
- re-routed the entire board so far, as it is routed very bad

## 28/5/26

- made 2 pages in the schematic for the power systems and for the MCU and 4.5v switching for the output to the string lights

## 6/6/26

Fun date

- Found the screw terminal i want to use to connect the 4.5v output to the string light leads
- looked into the 3.7v to 4.5v converter i want to use

## 01/07/26

- finished the 4.5v boost circut

## 02/07/26

- re-did the 4.5v boost circut but remembered to save it this time lol
- added test-points for the +4.5v and +3.3v rails so that i can test that the converters are working correctly
- added a test point for the VUSB net so that i can check that the correct voltage (5v) is being negotiated by the usb-c sink
- added a power switch to the output from the BMS
- added reset button
- applied parts to some of the passives i had placed over time

## 03/07/26

- added smoothing caps to the usb data lines
- connected the enable pin of the TPS61254YFFR(4.5v boost ic) to GPIO-1 on the esp32 so that i can control it from EspHome by driving the pin high
- put no-connect flags on all the unused pins
- started to layout the PCB for the (hopefully final time) whilst doing so, checking over the schematic for every part

## 04/07/26

- finished layout of the PCB
- added a little silkscreen message :)
- changed the size of the vias on the ground pin of the esp32-s3 as they were too small for JLCPCB
- made sure that the ground plane was not under the antenna of the esp32 so that the performance of wifi is less affected
- checked ordering through JLCPCB to make sure that they can make it all
- found that PCBA is super expensive, looking at soldering the parts myself
- finding replacements for some parts because they are out of stock

## 05/07/26

all of the changes i am making today are as a result of asking for someone to look over my schematic on ([#electronics](https://hackclub.slack.com/archives/C056AMWSFKJ/p1783166697054009)) in Slack and getting feedback :)
today i am going to:

- [X] Remove the PD sink and replace it with 2 5.k resistors to reduce cost. As i am getting 5v from the usb-c supply, i don't need to use a sink because it does not require proper PD negotiation, and it can request 5v from any usb-c source by just putting a 5.1k resistor to ground on each cc pin
  - removed the sink and placed the resistors
- [X] replace the esp32-s3 with and esp32-c3 to reduce cost, as the s3 is more powerful than i need for this application
  - change up the boot button so that it holds GPIO9 high when not pressed
  - connect up all the other parts
- [X] use the PWM pins on the c3 to allow for dimming for the lights
  - found a MOSFET to take the 3.3v PWM output from the esp32 and turn it into a 4.5v PWM output for the load
  - set up the MOSFET to transform the PWM signal from the ESP32 to a 4.5v PWM output for the lights
- finished the layout of the PCB
- removed the 0 ohm resistors as they are unnecessary for the length of my usb data lines
- 4 m3 mounting holes

## 06/07/26

- changed my 3.3v source, the one i was using, LCSC dont have carry anymore
  - im now going to be using the TI TPS63001DRCR
- found the inductor i want to be using, i got it from the recommended parts list from TI.
  - placed all the resistors and caps needed
  - finished the layout for the 3.3v source
- checked ordering at JLCPCB to make sure there arent any problems
  - replace R2 and R6 as the ones i had selected are now out of stock at LCSC
- whilst i was checking the JLCPCB ordering, i found that the 4.5v boost ic i was using is not compatible with the economic PCBA with JLCPCB, and can only be done with the standard PCBA, which costs around $145. due to the package size i cannot solder it myself, so i must find an alternative ic
  - found the ME2188A45, it is a working alternative for the TPS61254YFFR
  - placed and assembled it on the schematic
  - finished the layout on the PCB, and beefed up some of the traces that will be taking high current
  
## 08/07/26

- started modeling the base of the enclosure
  - created the basic outside shape
  - added the bases for the threaded inserts to hold in the PCB

## 09/07/26

- added vents to one side of the base of the enclosure
- added vents to the opposite side to the usb-c port
- sliced the base of the enclosure to get a better feel for how it will print, i think i need to make the walls between the vents a bit bigger, it looks like it will be a bit too fragile
  - made the gaps between each of the vents bigger
- finished up the base (for now)
  - except i still need to find some threaded inserts for the bolts from the PCB to go into, and need to figure out how i am going to attach the top and bottom pieces of the enclosure together
- printed the base as it is now so that i can make sure that the bottom and top fit together properly
- the base finished printing, i think that the vents are still too a bit weak, i need to make the gaps between the holes bigger.
- 