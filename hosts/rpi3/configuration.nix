{
  pkgs,
  lib,
  modulesPath,
  config,
  ...
}:

{
  imports = [
    # SD card build instructions and filesystem configuration
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    ./hardware-configuration.nix
  ];

  pers = {
    tty.enable = true;
    server.enable = true;
    sops = {
      enable = true;
      user = true;
    };
    openssh.enable = true;
    networkmanager.enable = true;
    git.enable = true;
    basic.enable = true;
    users = {
      enable = true;
      extraGroups = [
        "audio"
        "gpio"
        "pipewire"
      ];
    };
    pipewire.enable = true;
    tailscale.enable = true;
    raspberry.enable = true;
  };

  system.stateVersion = "25.05";

  # System packages
  environment.systemPackages = with pkgs; [ libraspberrypi ];

  time.timeZone = config.sensitive.timeZone;

  # Audio
  services.pipewire = {
    systemWide = true;
    alsa.support32Bit = true;
  };

  # TODO: Update this declaratively
  sdImage = {
    populateFirmwareCommands =
      let
        configTxt = pkgs.writeText "config.txt" ''
          [pi3]
          kernel=u-boot-rpi3.bin

          # Otherwise the serial output will be garbled.
          core_freq=250

          [pi02]
          kernel=u-boot-rpi3.bin

          [pi4]
          kernel=u-boot-rpi4.bin
          enable_gic=1
          armstub=armstub8-gic.bin

          # Otherwise the resolution will be weird in most cases, compared to
          # what the pi3 firmware does by default.
          disable_overscan=1

          # Supported in newer board revisions
          arm_boost=1

          [cm4]
          # Enable host mode on the 2711 built-in XHCI USB controller.
          # This line should be removed if the legacy DWC2 controller is required
          # (e.g. for USB device mode) or if USB support is not required.
          otg_mode=1

          [all]
          # Boot in 64-bit mode.
          arm_64bit=1

          # U-Boot needs this to work, regardless of whether UART is actually used or not.
          # Look in arch/arm/mach-bcm283x/Kconfig in the U-Boot tree to see if this is still
          # a requirement in the future.
          enable_uart=1

          # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
          # when attempting to show low-voltage or overtemperature warnings.
          avoid_warnings=1

          [all]
          # Custom added by me

          # Enable audio (loads snd_bcm2835)
          dtparam=audio=on

          # Automatically load overlays for detected cameras
          camera_auto_detect=1

          # Automatically load overlays for detected DSI dislpays
          display_auto_detect=1

          # Enable DRM VC4 V3D driver
          dtoverlay=vc4-kms-v3d
          max_framebuffers=2

          # Enable camera (not needed for now)
          # start_x=1
          # gpu_mem=128
        '';
      in
      lib.mkForce ''
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)

        # Add the config
        cp ${configTxt} firmware/config.txt

        # Add pi3 specific files
        cp ${pkgs.ubootRaspberryPi3_64bit}/u-boot.bin firmware/u-boot-rpi3.bin
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-2-b.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-3-b.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-3-b-plus.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-cm3.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-zero-2.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2710-rpi-zero-2-w.dtb firmware/

        # Add pi4 specific files - REMOVED BY ME
        # cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin firmware/u-boot-rpi4.bin
        # cp ${pkgs.raspberrypi-armstubs}/armstub8-gic.bin firmware/armstub8-gic.bin
        # cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-4-b.dtb firmware/
        # cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-400.dtb firmware/
        # cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4.dtb firmware/
        # cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4s.dtb firmware/
      '';
  };

  # Though if we do use it, then we can set the above declaratively I think
  boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
}
