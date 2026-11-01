{ config, pkgs, ... }:

{
  # Add libinput quirks for this specific touchpad
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Dell Inspiron 3525 Goodix Touchpad]
    MatchBus=i2c
    MatchVendor=0x27C6
    MatchProduct=0x0D43
    AttrInputProp=+INPUT_PROP_PRESSUREPAD
  '';
}