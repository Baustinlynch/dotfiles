## 8/5/26
- Found the ESP-32 MCU i want to use ([ESPRESSIF ESP32-S3-WROOM-1-N8](https://www.lcsc.com/product-detail/C2913198.html?s_z=n_q_esp32-S3%2520wroom&spm=wm.fly.bg.0.xh&lcsc_vid=RAALBlxfRVNXA1xQFAVeUlQHEgMNX1dfRlReAwIAQVExVlNRT1NbUlNfRVVaUTsOAxUeFF5JWBYZEEoKFBINSQcJGk4dAgUUFAk%3D))
- [Found 18650 battery mount tray ](https://www.lcsc.com/product-detail/C2988620.html?s_z=n_q_18650%2520battery%2520holder&spm=wm.fly.bg.0.cbh&lcsc_vid=RAALBlxfRVNXA1xQFAVeUlQHEgMNX1dfRlReAwIAQVExVlNRT1NbUFRWQVVeVjsOAxUeFF5JWBYZEEoKFBINSQcJGk4%3D)
- Got the [USB-C Port](https://www.lcsc.com/product-detail/C2689970.html?s_z=n_q_C2689970&globalKeyword=C2689970)
- Got the [PD sink from a previous project](https://www.lcsc.com/product-detail/C22373734.html?s_z=n_q_C22373734&globalKeyword=C22373734)
- Find the Battery charger ic i want to use ([the TP4056][https://www.lcsc.com/product-detail/C16581.html?s_z=n_q_TP4056&spm=wm.fly.bg.0.xh&lcsc_vid=RAALBlxfRVNXA1xQFAVeUlQHEgMNX1dfRlReAwIAQVExVlNRT1NYV1VXQFRZVDsOAxUeFF5JWBYZEEoKFBINSQcJGk4NBhADEA4cHktXR1FaSQwSGg0%3D])
    - Spent a while setting the battery charging circut up

- Started the Layout and roughting on the PCB
https://lapse.hackclub.com/timelapse/oYXOqTZ7uB9a
## 9/5/26 
- did a bit more roughting and declared some parts
## 27/5/26 
- found the BMS ic i want to use [here](https://www.lcsc.com/product-detail/C351410.html)
- also found a better data sheet from [Digikey](https://www.digikey.co.uk/en/products/detail/shenzhen-slkormicro-semicon-co-ltd/DW01A/28143000) because the one on lcsc was a bit too vauge
- finished the 3.7v battery system schematic
- re-routed the entire board so far, as it is routed very bad

## 28/5/26
- made 2 pages in the schematic for the power systems and for the mcu and 4.5v switching for the output to the string lights

## 6/6/26
Fun date
- Found the screw terminal i want to use to connect the 4.5v output to the string light leads
- looked into the 3.7v to 4.5v converter i want to use

## 01/07/26
- finished the 4.5v boost circut

## 02/07/26
- re-did the 4.5v boost circut but remembered to save it this time lol
- added testpoints for the +4.5v and +3.3v rails so that i can test that the converters are working correctlly 
- added a test point for the VUSB net so that i can check that the correct voltage (5v) is being negotiated by the usb-c sink
- added a power switch to the output from the bms 
- added reset button 
- applied parts to some of the passives i had placed over time

## 03/07/26
- added smoothing caps to the usb data lines
- connected the enable pin of the TPS61254YFFR(4.5v boost ic) to GPIO-1 on the esp32 so that i can control it from esphome by driving the pin high 
- put no-connect flags on all the unused pins 
- started to layout the PCB for the (hopefully final time) whilst doing so, checking over the schematic for every part

## 04/07/26
- finished layout of the PCB
- added a little silkscreen message :)
- changed the size of the vias on the ground pin of the esp32-s3 as they were too small for jlcpcb
- made sure that the ground plane was not under the antenna of the esp32 so that the performance of wifi is less affected
- checked ordering through jlc pcb to make sure that they can make it all
- found that pcba is super expensive, looking at soldering the parts myself 
