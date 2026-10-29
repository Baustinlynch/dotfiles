{ config, pkgs, ... }:

let
  touchpad = {
    description = "Fix for Dell Inspiron 3525 Goodix touchpad (27C6:0D43) that stops working during click and drag";
    hardware = "Goodix haptic touchpad (27C6:0D43)";
  };
in {
  # Add libinput quirks for this specific touchpad
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Dell Inspiron 3525 Goodix Touchpad]
    MatchBus=i2c
    MatchVendor=0x27C6
    MatchProduct=0x0D43
    AttrInputProp=+INPUT_PROP_PRESSUREPAD
  '';
}