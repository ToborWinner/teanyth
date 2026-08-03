{
  lib,
  config,
  ...
}:

{
  options.pers.logiops.enable = lib.mkEnableOption "logiops";

  config.services.logiops = {
    /*
      [DEBUG] CID  | reprog? | fn key? | mouse key? | gesture support?
      [DEBUG] 0x50 |         |         | YES        |
      [DEBUG] 0x51 |         |         | YES        |
      [DEBUG] 0x52 | YES     |         | YES        | YES
      [DEBUG] 0x53 | YES     |         | YES        | YES <- back
      [DEBUG] 0x56 | YES     |         | YES        | YES <- forward
      [DEBUG] 0xc3 | YES     |         | YES        | YES <- gesture button
      [DEBUG] 0xc4 | YES     |         | YES        | YES <- mode switch
      [DEBUG] 0xd7 | YES     |         |            | YES
      [DEBUG] 0x1a0 | YES     |         | YES        | YES
      [DEBUG] Thumb wheel detected (0x2150), capabilities:
      [DEBUG] timestamp | touch | proximity | single tap
      [DEBUG] YES       | YES   | NO        | NO
      [DEBUG] Thumb wheel resolution: native (20), diverted (120)
    */

    enable = config.pers.logiops.enable;
    config = {
      devices = [
        {
          name = "MX Master 4";
          buttons = [
            {
              cid = 86; # 0x56 (forward)
              action = {
                type = "Keypress";
                keys = [ "KEY_F" ];
              };
            }
            {
              cid = 83; # 0x53 (back)
              action = {
                type = "Keypress";
                keys = [ "KEY_X" ];
              };
            }
            {
              cid = 195; # 0x195 (gesture)
              action = {
                type = "Keypress";
                keys = [ "KEY_M" ];
              };
            }
          ];
        }
      ];
    };
  };
}
