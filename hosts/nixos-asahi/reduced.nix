[
  [
    "/misc/nixpkgs.nix"
    [ 2 ]
  ]
  "/misc/extra-arguments.nix"
  "/config/appstream.nix"
  "/virtualisation/disk-size-option.nix"
  "/services/continuous-integration/github-runner/service.nix"
  "/virtualisation/libvirtd.nix"
  [
    "/tasks/network-interfaces.nix"
    {
      services = {
        mstpd = true;
      };
    }
  ]
  "/tasks/filesystems/overlayfs.nix"
  "/tasks/filesystems.nix"
  "/system/boot/systemd.nix"
  [
    "/system/boot/stage-1.nix"
    [
      [
        0
        { boot = true; }
      ]
    ]
  ]
  "/system/boot/loader/grub/grub.nix"
  "/system/boot/kernel.nix"
  "/system/boot/binfmt.nix"
  [
    "/system/activation/top-level.nix"
    [
      2
      1
      3
      4
    ]
  ]
  "/services/web-servers/fcgiwrap.nix"
  [
    "/services/security/authelia.nix"
    { users = true; }
  ]
  "/services/networking/networkmanager.nix"
  "/services/networking/iwd.nix"
  "/services/networking/firewall-iptables.nix"
  "/services/networking/firewall.nix"
  "/services/network-filesystems/samba.nix"
  [
    "/services/monitoring/prometheus/exporters.nix"
    {
      networking = {
        firewall = {
          extraInputRules = true;
        };
      };
    }
  ]
  "/services/misc/nix-optimise.nix"
  "/services/misc/nix-gc.nix"
  "/services/hardware/udev.nix"
  "/services/display-managers/default.nix"
  "/services/desktops/pipewire/wireplumber.nix"
  "/services/desktops/pipewire/pipewire.nix"
  "/services/databases/postgresql.nix"
  "/services/backup/restic.nix"
  "/services/backup/postgresql-backup.nix"
  "/security/wrappers/default.nix"
  "/security/systemd-confinement.nix"
  "/security/sudo.nix"
  "/security/pam.nix"
  "/programs/ssh.nix"
  "/programs/shadow.nix"
  "/programs/nh.nix"
  [
    "/misc/version.nix"
    [
      4
      3
      1
      2
    ]
  ]
  "/misc/nixpkgs-flake.nix"
  "/misc/nixops-autoluks.nix"
  [
    "/misc/documentation.nix"
    [
      9
      6
      7
      8
    ]
  ]
  "/hardware/graphics.nix"
  "/hardware/device-tree.nix"
  "/config/xdg/portal.nix"
  "/config/users-groups.nix"
  "/config/swap.nix"
  "/config/nsswitch.nix"
  "/config/nix-remote-build.nix"
  "/config/networking.nix"
  "/config/ldso.nix"
  [ "/misc/assertions.nix" ]
  "/tasks/bcache.nix"
  "/services/printing/cupsd.nix"
  "/system/boot/modprobe.nix"
  [ "/system/activation/bootspec.nix" ]
  [
    "/virtualisation/nixos-containers.nix"
    {
      networking = {
        dhcpcd = true;
      };
    }
  ]
  [
    "/services/networking/netbird.nix"
    {
      networking = {
        dhcpcd = true;
      };
    }
  ]
  "/system/boot/stage-2.nix"
  "/tasks/filesystems/ext.nix"
  "/tasks/filesystems/btrfs.nix"
  "/system/boot/clevis.nix"
  "/services/hardware/amdgpu.nix"
  "/config/console.nix"
  "/tasks/lvm.nix"
  "/services/system/dbus.nix"
  "/system/boot/systemd/dm-verity.nix"
  [ "/system/boot/systemd/initrd.nix" ]
  "/system/boot/systemd/fido2.nix"
  "/system/boot/systemd/repart.nix"
  "/system/boot/shutdown.nix"
  [
    "/services/misc/graphical-desktop.nix"
    { programs = true; }
  ]
  "/config/sysctl.nix"
  "/tasks/cpu-freq.nix"
  "/services/hardware/display.nix"
  [ "/system/boot/loader/efi.nix" ]
  "/system/boot/loader/external/external.nix"
  "/system/boot/loader/systemd-boot/systemd-boot.nix"
  [ "/system/boot/loader/loader.nix" ]
  "/system/boot/tmp.nix"
  "/misc/man-db.nix"
  "/misc/mandoc.nix"
  "/config/shells-environment.nix"
  "/config/system-path.nix"
  "/config/terminfo.nix"
  "/system/boot/timesyncd.nix"
  "/system/boot/systemd/user.nix"
  "/system/boot/systemd/tmpfiles.nix"
  "/system/boot/systemd/oomd.nix"
  "/system/boot/systemd/logind.nix"
  "/system/boot/systemd/journald.nix"
  "/system/boot/systemd/coredump.nix"
  [
    "/system/boot/networkd.nix"
    {
      networking = true;
      services = true;
    }
    [ ]
  ]
  [
    "/services/ttys/getty.nix"
    [
      1
      [
        0
        { services = true; }
      ]
    ]
  ]
  "/services/system/nscd.nix"
  "/services/networking/modemmanager.nix"
  "/services/misc/uhub.nix"
  "/services/hardware/udisks2.nix"
  "/services/hardware/bluetooth.nix"
  "/security/polkit.nix"
  "/security/ca.nix"
  "/programs/zsh/zsh.nix"
  "/programs/nano.nix"
  "/programs/git.nix"
  "/programs/fuse.nix"
  "/programs/dconf.nix"
  "/programs/bash/bash.nix"
  "/config/xdg/mime.nix"
  "/config/system-environment.nix"
  "/config/resolvconf.nix"
  "/config/nix-flakes.nix"
  "/config/nix.nix"
  "/config/locale.nix"
  "/config/i18n.nix"
  "/config/fonts/fontconfig.nix"
  [
    "/system/etc/etc.nix"
    [ ]
  ]
  "/programs/environment.nix"
  "/config/nix-channel.nix"
  "/config/stub-ld.nix"
  "/config/malloc.nix"
  "/programs/xwayland.nix"
  "/config/xdg/sounds.nix"
  "/config/xdg/menus.nix"
  "/config/xdg/icons.nix"
  "/config/xdg/autostart.nix"
  "/services/system/nix-daemon.nix"
  "/services/desktops/gnome/at-spi2-core.nix"
  "/services/accessibility/speechd.nix"
  "/virtualisation/spice-usb-redirection.nix"
  "/system/boot/kexec.nix"
  "/services/misc/spice-vdagentd.nix"
  "/security/rtkit.nix"
  "/programs/wayland/hyprland.nix"
  "/programs/virt-manager.nix"
  "/programs/skim.nix"
  "/programs/less.nix"
  "/programs/command-not-found/command-not-found.nix"
  "/system/activation/activation-script.nix"
  [ "/tasks/encrypted-devices.nix" ]
  "/config/fonts/packages.nix"
  [ "/config/fonts/fontdir.nix" ]
  "/services/audio/alsa.nix"
  "/services/hardware/amdvlk.nix"
  "/hardware/iosched.nix"
  "/hardware/ckb-next.nix"
  "/hardware/cpu/amd-ryzen-smu.nix"
  "/hardware/cpu/intel-sgx.nix"
  "/hardware/cpu/x86-msr.nix"
  "/hardware/all-firmware.nix"
  "/services/hardware/fancontrol.nix"
  "/hardware/i2c.nix"
  "/hardware/video/intel-gpu-tools.nix"
  "/hardware/libftdi.nix"
  "/hardware/mcelog.nix"
  "/hardware/new-lg4ff.nix"
  [
    "/hardware/nfc-nci.nix"
    {
      services = {
        pcscd = true;
      };
    }
  ]
  "/hardware/openrazer.nix"
  "/hardware/opentabletdriver.nix"
  "/services/hardware/rasdaemon.nix"
  "/hardware/rtl-sdr.nix"
  "/hardware/saleae-logic.nix"
  "/hardware/sata.nix"
  "/hardware/sensor/hddtemp.nix"
  [
    "/services/hardware/tuxedo-rs.nix"
    { hardware = true; }
  ]
  "/hardware/uni-sync.nix"
  "/hardware/xone.nix"
  "/hardware/xpadneo.nix"
  "/i18n/input-method/default.nix"
  "/misc/ids.nix"
  [ "/misc/lib.nix" ]
  [
    "/virtualisation/podman/network-socket.nix"
    [ ]
  ]
  "/services/networking/nat-iptables.nix"
  "/tasks/network-interfaces-scripted.nix"
  "/services/networking/jool.nix"
  [ "/services/networking/nat.nix" ]
  "/services/networking/nm-file-secret-agent.nix"
  [ "/services/networking/nftables.nix" ]
  "/services/networking/openconnect.nix"
  "/config/stevenblack.nix"
  "/services/networking/ucarp.nix"
  [ "/services/networking/wireguard.nix" ]
  "/services/networking/wpa_supplicant.nix"
  "/config/power-management.nix"
  "/programs/adb.nix"
  "/programs/alvr.nix"
  [
    "/programs/amnezia-vpn.nix"
    {
      services = {
        resolved = true;
      };
    }
  ]
  "/programs/appimage.nix"
  "/programs/bandwhich.nix"
  "/programs/bash/blesh.nix"
  "/programs/bash/bash-completion.nix"
  "/programs/bash/ls-colors.nix"
  "/programs/bash/undistract-me.nix"
  "/config/vte.nix"
  "/programs/bat.nix"
  "/programs/bazecor.nix"
  "/programs/benchexec.nix"
  "/programs/wayland/cardboard.nix"
  "/programs/cfs-zen-tweaks.nix"
  "/programs/clash-verge.nix"
  "/programs/coolercontrol.nix"
  "/hardware/corectrl.nix"
  "/programs/cpu-energy-meter.nix"
  [
    "/programs/digitalbitbox/default.nix"
    { hardware = true; }
  ]
  "/programs/direnv.nix"
  "/programs/dmrconfig.nix"
  "/programs/dublin-traceroute.nix"
  "/programs/envision.nix"
  "/services/desktops/gnome/evolution-data-server.nix"
  "/programs/fcast-receiver.nix"
  "/programs/firefox.nix"
  "/programs/firejail.nix"
  "/programs/fish.nix"
  "/programs/flashprog.nix"
  "/programs/foot"
  "/programs/fzf.nix"
  "/programs/gamemode.nix"
  "/programs/gamescope.nix"
  "/programs/geary.nix"
  "/programs/ghidra.nix"
  "/programs/gnome-disks.nix"
  "/programs/gnome-terminal.nix"
  "/programs/gphoto2.nix"
  "/programs/gpu-screen-recorder.nix"
  "/programs/hamster.nix"
  "/programs/wayland/hyprlock.nix"
  "/programs/iay.nix"
  [
    "/programs/iio-hyprland.nix"
    { hardware = true; }
  ]
  [
    "/programs/immersed.nix"
    [
      [
        0
        { programs = true; }
      ]
    ]
  ]
  "/programs/wayland/labwc.nix"
  "/programs/lazygit.nix"
  "/programs/localsend.nix"
  [
    "/programs/mepo.nix"
    {
      services = {
        gpsd = true;
      };
    }
  ]
  "/programs/minipro.nix"
  "/programs/miriway.nix"
  [
    "/programs/msmtp.nix"
    { services = true; }
  ]
  [
    "/programs/nautilus-open-any-terminal.nix"
    { programs = true; }
  ]
  "/programs/nethoscope.nix"
  "/programs/wayland/niri.nix"
  "/programs/nix-ld.nix"
  "/programs/nix-required-mounts.nix"
  "/programs/nm-applet.nix"
  "/programs/nncp.nix"
  "/programs/ns-usbloader.nix"
  "/programs/obs-studio.nix"
  "/programs/oddjobd.nix"
  [
    "/programs/opengamepadui.nix"
    {
      hardware = {
        steam-hardware = true;
      };
    }
  ]
  "/programs/openvpn3.nix"
  "/programs/partition-manager.nix"
  "/programs/pay-respects.nix"
  "/programs/plotinus.nix"
  "/programs/pqos-wrapper.nix"
  "/programs/projecteur.nix"
  "/programs/proxychains.nix"
  "/programs/qdmr.nix"
  "/programs/qgroundcontrol.nix"
  "/programs/quark-goldleaf.nix"
  "/programs/wayland/river.nix"
  "/programs/rog-control-center.nix"
  "/programs/rust-motd.nix"
  "/programs/ryzen-monitor-ng.nix"
  "/programs/sniffnet.nix"
  "/programs/starship.nix"
  [
    "/programs/steam.nix"
    {
      hardware = {
        steam-hardware = true;
      };
    }
  ]
  "/programs/streamcontroller.nix"
  "/programs/streamdeck-ui.nix"
  "/programs/wayland/sway.nix"
  "/programs/thunar.nix"
  "/programs/thunderbird.nix"
  "/programs/tmux.nix"
  "/programs/trippy.nix"
  "/programs/tsm-client.nix"
  "/programs/wayland/uwsm.nix"
  "/programs/vivid.nix"
  "/programs/wayland/waybar.nix"
  "/programs/wayland/wayfire.nix"
  "/programs/wayland/miracle-wm.nix"
  "/programs/wshowkeys.nix"
  "/programs/xastir.nix"
  "/programs/xfconf.nix"
  "/programs/yazi.nix"
  "/programs/ydotool.nix"
  "/programs/zsh/oh-my-zsh.nix"
  "/config/qt.nix"
  "/security/acme"
  "/security/misc.nix"
  [
    "/security/apparmor.nix"
    [
      1
      0
    ]
  ]
  "/security/audit.nix"
  "/security/dhparams.nix"
  "/security/doas.nix"
  "/security/krb5"
  "/security/lock-kernel-modules.nix"
  [ "/security/pam_mount.nix" ]
  [ "/security/oath.nix" ]
  "/services/display-managers/greetd.nix"
  "/security/soteria.nix"
  "/security/sudo-rs.nix"
  "/security/tpm2.nix"
  "/services/networking/3proxy.nix"
  "/services/desktops/accountsservice.nix"
  "/services/web-apps/actual.nix"
  [
    "/services/web-apps/akkoma.nix"
    { services = true; }
  ]
  "/services/monitoring/alloy.nix"
  "/services/misc/ananicy.nix"
  "/services/misc/anki-sync-server.nix"
  [
    "/services/web-apps/anuko-time-tracker.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  "/services/misc/apache-kafka.nix"
  "/services/monitoring/arbtt.nix"
  "/services/games/archisteamfarm.nix"
  [
    "/services/web-apps/archtika.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/networking/aria2.nix"
  "/services/web-apps/artalk.nix"
  "/services/hardware/asusd.nix"
  "/services/development/athens.nix"
  "/services/web-apps/audiobookshelf.nix"
  "/services/hardware/auto-cpufreq.nix"
  "/services/hardware/auto-epp.nix"
  "/services/misc/autorandr.nix"
  "/services/misc/autosuspend.nix"
  [ "/services/networking/avahi-daemon.nix" ]
  "/services/desktops/ayatana-indicators.nix"
  "/services/networking/babeld.nix"
  "/services/desktops/bamf.nix"
  "/services/networking/bee.nix"
  "/services/misc/bees.nix"
  "/services/monitoring/below.nix"
  "/services/networking/biboumi.nix"
  "/services/networking/bird.nix"
  "/services/networking/bird-lg.nix"
  "/services/networking/bitcoind.nix"
  "/services/torrent/bitmagnet.nix"
  "/services/security/bitwarden-directory-connector-cli.nix"
  "/services/development/blackfire.nix"
  [
    "/services/misc/blenderfarm.nix"
    { networking = true; }
  ]
  "/services/networking/blockbook-frontend.nix"
  [
    "/services/web-apps/bluemap.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/computing/boinc/client.nix"
  "/services/desktops/bonsaid.nix"
  [
    "/services/web-apps/bookstack.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  [
    "/services/backup/borgbackup.nix"
    { users = true; }
  ]
  "/services/audio/botamusique.nix"
  "/services/system/bpftune.nix"
  "/services/backup/btrbk.nix"
  "/services/hardware/buffyboard.nix"
  "/services/continuous-integration/buildbot/master.nix"
  "/services/continuous-integration/buildbot/worker.nix"
  "/services/continuous-integration/buildkite-agents.nix"
  "/services/web-apps/c2fmzq-server.nix"
  "/services/system/cachix-agent/default.nix"
  "/services/system/cachix-watch-store.nix"
  "/services/monitoring/cadvisor.nix"
  "/services/wayland/cage.nix"
  "/services/misc/calibre-server.nix"
  "/services/web-apps/calibre-web.nix"
  [
    "/services/security/canaille.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/databases/cassandra.nix"
  [
    "/services/web-apps/castopod.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  "/services/monitoring/certspotter.nix"
  "/services/networking/chisel-server.nix"
  "/services/databases/chromadb.nix"
  "/services/mail/clamsmtp.nix"
  "/services/system/cloud-init.nix"
  "/services/networking/cloudflare-warp.nix"
  "/services/networking/cloudflared.nix"
  [
    "/services/web-apps/cloudlog.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  "/services/monitoring/cockpit.nix"
  "/services/databases/cockroachdb.nix"
  "/services/web-apps/code-server.nix"
  "/services/web-apps/coder.nix"
  "/services/web-apps/collabora-online.nix"
  "/services/web-apps/commafeed.nix"
  "/services/matrix/conduwuit.nix"
  [
    "/services/networking/connman.nix"
    [
      [
        0
        { services = true; }
      ]
    ]
  ]
  "/services/security/vault-agent.nix"
  "/services/networking/corerad.nix"
  "/services/networking/crab-hole.nix"
  "/services/networking/create_ap.nix"
  "/services/networking/croc.nix"
  "/services/scheduling/cron.nix"
  "/services/networking/dae.nix"
  "/services/networking/dante.nix"
  [
    "/services/web-apps/davis.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  [
    "/services/misc/db-rest.nix"
    { services = true; }
  ]
  "/services/desktops/deepin/app-services.nix"
  "/services/desktops/deepin/dde-api.nix"
  "/services/desktops/deepin/dde-daemon.nix"
  "/services/matrix/dendrite.nix"
  [
    "/services/web-apps/dependency-track.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  [
    "/services/desktop-managers/lomiri.nix"
    {
      services = {
        upower = true;
      };
    }
  ]
  "/services/web-apps/dex.nix"
  "/services/databases/dgraph.nix"
  [
    "/services/web-apps/discourse.nix"
    {
      services = {
        nginx = true;
        redis = true;
      };
    }
  ]
  "/services/display-managers/ly.nix"
  [ "/services/display-managers/sddm.nix" ]
  "/services/x11/display-managers/default.nix"
  "/services/mail/dkimproxy-out.nix"
  "/services/networking/dnscrypt-proxy2.nix"
  "/services/networking/dnsmasq.nix"
  "/services/networking/dnsproxy.nix"
  "/services/networking/doh-proxy-rust.nix"
  "/services/networking/doh-server.nix"
  [
    "/services/web-apps/dokuwiki.nix"
    { services = true; }
  ]
  "/services/mail/dovecot.nix"
  "/services/misc/duckdns.nix"
  [
    "/services/system/earlyoom.nix"
    { services = true; }
  ]
  "/services/home-automation/ebusd.nix"
  [
    "/services/web-apps/echoip.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/hardware/network/eg25-manager.nix"
  "/services/web-apps/eintopf.nix"
  "/services/editors/emacs.nix"
  "/services/security/endlessh.nix"
  "/services/security/endlessh-go.nix"
  [
    "/services/video/epgstation/default.nix"
    {
      services = {
        mirakurun = true;
      };
    }
  ]
  "/services/networking/epmd.nix"
  "/services/networking/ergochat.nix"
  "/services/network-filesystems/eris-server.nix"
  "/services/security/esdm.nix"
  "/services/desktops/espanso.nix"
  "/services/home-automation/esphome.nix"
  "/services/networking/eternal-terminal.nix"
  "/services/home-automation/evcc.nix"
  "/services/networking/expressvpn.nix"
  "/services/networking/fakeroute.nix"
  [
    "/services/networking/fastnetmon-advanced.nix"
    {
      services = {
        clickhouse = true;
      };
    }
  ]
  [
    "/services/networking/fedimintd.nix"
    { services = true; }
  ]
  "/services/databases/ferretdb.nix"
  "/services/web-apps/fider.nix"
  [
    "/services/web-apps/filesender.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
        simplesamlphp = true;
      };
    }
  ]
  [
    "/services/networking/firefox-syncserver.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  [
    "/services/web-apps/flarum.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  "/services/desktops/flatpak.nix"
  "/services/torrent/flood.nix"
  [
    "/services/computing/foldingathome/client.nix"
    [
      2
      [
        0
        { services = true; }
      ]
      1
    ]
  ]
  [
    "/services/misc/forgejo.nix"
    {
      services = {
        mysql = true;
        postgresql = true;
      };
    }
  ]
  "/services/databases/foundationdb.nix"
  [ "/services/security/fprintd.nix" ]
  "/services/games/freeciv.nix"
  [
    "/services/web-apps/freshrss.nix"
    { services = true; }
  ]
  [
    "/services/video/frigate.nix"
    {
      hardware = true;
      services = true;
    }
  ]
  "/services/networking/frp.nix"
  "/services/misc/fstrim.nix"
  "/services/hardware/fwupd.nix"
  "/services/hardware/g810-led.nix"
  "/services/web-apps/galene.nix"
  "/services/web-servers/garage.nix"
  "/services/monitoring/gatus.nix"
  "/services/desktops/geoclue2.nix"
  "/services/misc/geoipupdate.nix"
  "/services/web-apps/gerrit.nix"
  [
    "/services/networking/ghostunnel.nix"
    { systemd = true; }
  ]
  [
    "/services/misc/gitea.nix"
    {
      services = {
        mysql = true;
        postgresql = true;
      };
    }
  ]
  "/services/continuous-integration/gitea-actions-runner.nix"
  [ "/services/continuous-integration/github-runner/options.nix" ]
  [
    "/services/misc/gitlab.nix"
    {
      services = {
        dockerRegistry = true;
        redis = true;
      };
    }
  ]
  [
    "/services/continuous-integration/gitlab-runner.nix"
    { virtualisation = true; }
  ]
  "/services/monitoring/gitwatch.nix"
  "/services/web-apps/glance.nix"
  "/services/monitoring/glances.nix"
  [
    "/services/x11/desktop-managers/gnome.nix"
    {
      programs = {
        evince = true;
        file-roller = true;
        seahorse = true;
      };
      services = {
        colord = true;
        dleyna-renderer = true;
        dleyna-server = true;
        hardware = true;
        libinput = true;
        orca = true;
        power-profiles-daemon = true;
        system-config-printer = true;
        upower = true;
      };
    }
  ]
  "/services/desktops/gnome/glib-networking.nix"
  "/services/desktops/gnome/gnome-browser-connector.nix"
  "/services/desktops/gnome/gnome-initial-setup.nix"
  "/services/desktops/gnome/gnome-keyring.nix"
  "/services/desktops/gnome/gnome-online-accounts.nix"
  "/services/desktops/gnome/gnome-remote-desktop.nix"
  "/services/desktops/gnome/gnome-settings-daemon.nix"
  "/services/desktops/gnome/gnome-user-share.nix"
  "/services/desktops/gnome/localsearch.nix"
  "/services/desktops/gnome/rygel.nix"
  "/services/desktops/gnome/sushi.nix"
  "/services/desktops/gnome/tinysparql.nix"
  "/services/networking/gns3-server.nix"
  "/services/networking/go-autoconfig.nix"
  "/services/networking/go-neb.nix"
  "/services/video/go2rtc/default.nix"
  "/services/web-apps/goatcounter.nix"
  "/services/mail/goeland.nix"
  "/services/misc/gollum.nix"
  "/services/audio/gonic.nix"
  "/services/monitoring/goss.nix"
  "/services/misc/gotenberg.nix"
  "/services/web-apps/gotify-server.nix"
  "/services/web-apps/gotosocial.nix"
  "/services/home-automation/govee2mqtt.nix"
  "/services/audio/goxlr-utility.nix"
  "/services/monitoring/grafana-agent.nix"
  [
    "/services/monitoring/grafana-image-renderer.nix"
    {
      services = {
        grafana = true;
      };
    }
  ]
  [
    "/services/web-apps/grocy.nix"
    { services = true; }
  ]
  "/services/desktops/gsignond.nix"
  "/services/misc/guix"
  "/services/desktops/gvfs.nix"
  "/services/hardware/handheld-daemon.nix"
  "/services/networking/hans.nix"
  "/services/hardware/argonone.nix"
  "/services/hardware/lcd.nix"
  "/services/hardware/openrgb.nix"
  "/services/web-apps/hatsu.nix"
  "/services/networking/headscale.nix"
  "/services/matrix/hebbot.nix"
  [
    "/services/web-apps/hedgedoc.nix"
    [
      3
      [
        0
        { services = true; }
      ]
      2
      1
    ]
  ]
  "/services/misc/heisenbridge.nix"
  [ "/services/continuous-integration/hercules-ci-agent/common.nix" ]
  "/services/networking/hickory-dns.nix"
  "/services/web-apps/hledger-web.nix"
  "/services/security/hockeypuck.nix"
  "/services/security/hologram-agent.nix"
  "/services/home-automation/home-assistant.nix"
  "/services/web-apps/homebox.nix"
  [ "/system/boot/systemd/homed.nix" ]
  "/services/web-apps/honk.nix"
  "/services/networking/hostapd.nix"
  "/services/search/hound.nix"
  "/services/networking/https-dns-proxy.nix"
  [ "/services/networking/hylafax/options.nix" ]
  "/services/wayland/hypridle.nix"
  "/services/networking/icecream/daemon.nix"
  "/services/networking/icecream/scheduler.nix"
  [
    "/services/web-apps/icingaweb2/icingaweb2.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  "/services/web-apps/ifm.nix"
  "/services/networking/imaginary.nix"
  "/services/databases/influxdb2.nix"
  "/services/misc/input-remapper.nix"
  "/services/hardware/inputplumber.nix"
  "/services/networking/inspircd.nix"
  "/services/security/intune.nix"
  [
    "/services/misc/invidious-router.nix"
    { services = true; }
  ]
  "/services/hardware/iptsd.nix"
  [
    "/services/networking/ivpn.nix"
    {
      networking = {
        iproute2 = true;
      };
    }
  ]
  "/services/audio/jack.nix"
  "/services/misc/jellyfin.nix"
  "/services/misc/jellyseerr.nix"
  "/services/networking/jibri/default.nix"
  "/services/networking/jicofo.nix"
  "/services/networking/jigasi.nix"
  [
    "/services/web-apps/jirafeau.nix"
    { services = true; }
  ]
  [
    "/services/web-apps/jitsi-meet.nix"
    {
      services = {
        caddy = true;
        nginx = true;
      };
    }
  ]
  "/services/networking/jitsi-videobridge.nix"
  "/services/security/jitterentropy-rngd.nix"
  "/services/audio/jmusicbot.nix"
  "/services/networking/jotta-cli.nix"
  "/system/boot/systemd/journald-gateway.nix"
  "/system/boot/systemd/journald-remote.nix"
  "/system/boot/systemd/journald-upload.nix"
  "/services/logging/journalwatch.nix"
  "/services/development/jupyter/default.nix"
  "/services/development/jupyterhub/default.nix"
  "/services/cluster/k3s/default.nix"
  [
    "/services/hardware/kanata.nix"
    { hardware = true; }
  ]
  [
    "/services/web-apps/kanboard.nix"
    { services = true; }
  ]
  "/services/security/kanidm.nix"
  "/services/web-apps/kavita.nix"
  "/services/networking/kea.nix"
  "/services/networking/keepalived/default.nix"
  [
    "/services/system/kerberos/default.nix"
    [ 0 ]
  ]
  "/services/web-servers/keter"
  "/services/web-apps/keycloak.nix"
  "/services/misc/klipper.nix"
  [
    "/services/hardware/kmonad.nix"
    { hardware = true; }
  ]
  "/services/web-apps/komga.nix"
  "/services/networking/kresd.nix"
  "/services/cluster/kubernetes/addon-manager.nix"
  [
    "/services/cluster/kubernetes/apiserver.nix"
    {
      services = {
        etcd = true;
      };
    }
  ]
  "/services/cluster/kubernetes/controller-manager.nix"
  [
    "/services/cluster/kubernetes/default.nix"
    {
      services = {
        etcd = true;
        flannel = true;
        kubernetes = {
          addons = true;
        };
      };
      virtualisation = true;
    }
  ]
  [
    "/services/cluster/kubernetes/flannel.nix"
    {
      networking = {
        dhcpcd = true;
      };
      services = {
        flannel = true;
      };
    }
  ]
  "/services/cluster/kubernetes/kubelet.nix"
  [
    "/services/cluster/kubernetes/pki.nix"
    {
      services = {
        certmgr = true;
        cfssl = true;
        etcd = true;
        flannel = true;
      };
    }
  ]
  "/services/cluster/kubernetes/proxy.nix"
  "/services/cluster/kubernetes/scheduler.nix"
  "/services/network-filesystems/kubo.nix"
  [
    "/services/web-apps/lanraragi.nix"
    { services = true; }
  ]
  [
    "/services/web-apps/lemmy.nix"
    {
      services = {
        caddy = true;
        nginx = true;
      };
    }
  ]
  [
    "/services/monitoring/librenms.nix"
    {
      programs = true;
      services = {
        memcached = true;
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  "/services/misc/lifecycled.nix"
  "/services/network-filesystems/litestream/default.nix"
  "/services/development/livebook.nix"
  "/services/misc/llama-cpp.nix"
  "/misc/locate.nix"
  "/services/logging/logrotate.nix"
  "/services/networking/magic-wormhole-mailbox-server.nix"
  "/services/torrent/magnetico.nix"
  [
    "/services/mail/mailhog.nix"
    { services = true; }
  ]
  [
    "/services/mail/mailman.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/mail/mailpit.nix"
  "/services/misc/mame.nix"
  "/services/search/manticore.nix"
  [
    "/services/web-apps/mastodon.nix"
    {
      services = {
        nginx = true;
        redis = true;
      };
    }
  ]
  [
    "/services/web-apps/matomo.nix"
    { services = true; }
  ]
  "/services/matrix/appservice-discord.nix"
  "/services/matrix/appservice-irc.nix"
  "/services/matrix/conduit.nix"
  "/services/matrix/hookshot.nix"
  [
    "/services/matrix/synapse.nix"
    {
      services = {
        redis = true;
      };
    }
  ]
  "/services/home-automation/matter-server.nix"
  "/services/web-apps/mattermost.nix"
  "/services/matrix/maubot.nix"
  "/services/matrix/mautrix-meta.nix"
  "/services/matrix/mautrix-signal.nix"
  "/services/matrix/mautrix-telegram.nix"
  "/services/matrix/mautrix-whatsapp.nix"
  "/services/games/mchprs.nix"
  "/services/video/mediamtx.nix"
  "/services/search/meilisearch.nix"
  "/services/admin/meshcentral.nix"
  "/services/web-apps/microbin.nix"
  "/services/web-servers/mighttpd2.nix"
  "/services/networking/mihomo.nix"
  "/services/web-servers/minio.nix"
  [
    "/services/web-apps/misskey.nix"
    {
      services = {
        caddy = true;
        nginx = true;
        redis = true;
      };
    }
  ]
  "/services/matrix/mjolnir.nix"
  [
    "/services/web-apps/mobilizon.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/misc/mollysocket.nix"
  "/services/hardware/monado.nix"
  "/services/networking/monero.nix"
  "/services/databases/monetdb.nix"
  "/services/monitoring/monit.nix"
  "/services/misc/moonraker.nix"
  "/services/networking/mosquitto.nix"
  "/services/networking/mozillavpn.nix"
  "/services/networking/mptcpd.nix"
  "/services/networking/mtr-exporter.nix"
  "/services/networking/mullvad-vpn.nix"
  [ "/services/networking/multipath.nix" ]
  "/services/networking/murmur.nix"
  "/services/audio/music-assistant.nix"
  "/services/matrix/mx-puppet-discord.nix"
  "/services/networking/mycelium.nix"
  "/services/audio/mympd.nix"
  "/services/databases/mysql.nix"
  "/services/backup/mysql-backup.nix"
  [
    "/services/monitoring/nagios.nix"
    { services = true; }
  ]
  "/services/networking/namecoind.nix"
  "/services/networking/nar-serve.nix"
  "/services/audio/navidrome.nix"
  "/services/networking/ncdns.nix"
  "/services/networking/ncps.nix"
  "/services/networking/nebula.nix"
  "/services/databases/neo4j.nix"
  "/services/networking/netclient.nix"
  [
    "/services/web-apps/nextcloud.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
        redis = true;
      };
    }
  ]
  "/services/web-apps/nextcloud-whiteboard-server.nix"
  "/services/web-apps/nextjs-ollama-llm-ui.nix"
  "/services/web-apps/nexus.nix"
  "/services/monitoring/nezha-agent.nix"
  [
    "/services/web-servers/nginx/gitweb.nix"
    { services = true; }
  ]
  [
    "/services/web-servers/nginx/tailscale-auth.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/networking/nix-store-gcs-proxy.nix"
  "/services/web-apps/nostr-rs-relay.nix"
  "/services/misc/novacomd.nix"
  "/services/networking/nsd.nix"
  "/services/networking/ntp/ntpd-rs.nix"
  "/services/web-apps/ocis.nix"
  "/services/monitoring/ocsinventory-agent.nix"
  "/services/misc/ollama.nix"
  [
    "/services/web-apps/open-web-calendar.nix"
    { services = true; }
  ]
  "/services/misc/open-webui.nix"
  "/services/networking/opengfw.nix"
  "/services/databases/openldap.nix"
  "/services/security/opensnitch.nix"
  [ "/services/networking/ssh/sshd.nix" ]
  "/services/web-apps/openvscode-server.nix"
  "/services/misc/owncast.nix"
  "/services/matrix/pantalaimon.nix"
  [
    "/services/x11/desktop-managers/pantheon.nix"
    {
      programs = {
        evince = true;
        file-roller = true;
      };
      services = {
        colord = true;
        libinput = true;
        orca = true;
        power-profiles-daemon = true;
        switcherooControl = true;
        system-config-printer = true;
        upower = true;
        xserver = {
          displayManager = true;
        };
      };
    }
  ]
  [
    "/services/misc/paperless.nix"
    {
      services = {
        redis = true;
      };
    }
    [
      [
        0
        { services = true; }
      ]
      1
    ]
  ]
  [
    "/services/monitoring/parsedmarc.nix"
    {
      services = {
        elasticsearch = true;
        grafana = true;
      };
    }
  ]
  "/services/security/pass-secret-service.nix"
  "/services/cluster/patroni/default.nix"
  "/services/networking/pdns-recursor.nix"
  "/services/web-apps/pds.nix"
  [
    "/services/web-apps/peering-manager.nix"
    {
      services = {
        redis = true;
      };
    }
  ]
  "/services/networking/peroxide.nix"
  "/services/misc/persistent-evdev.nix"
  "/services/databases/pgbouncer.nix"
  "/services/web-apps/photoprism.nix"
  "/services/web-apps/phylactery.nix"
  [
    "/services/x11/picom.nix"
    [
      2
      1
      [
        0
        { services = true; }
      ]
    ]
  ]
  "/services/web-apps/pict-rs.nix"
  [
    "/services/web-apps/pingvin-share.nix"
    { services = true; }
  ]
  "/services/misc/pinnwand.nix"
  "/services/networking/pixiecore.nix"
  "/services/web-apps/plantuml-server.nix"
  [
    "/services/web-apps/plausible.nix"
    {
      services = {
        clickhouse = true;
      };
    }
  ]
  "/services/desktops/playerctld.nix"
  "/services/networking/pleroma.nix"
  "/services/misc/podgrab.nix"
  "/services/misc/polaris.nix"
  "/services/web-apps/porn-vault/default.nix"
  "/services/misc/portunus.nix"
  [ "/services/mail/postfix.nix" ]
  "/services/backup/postgresql-wal-receiver.nix"
  "/services/web-apps/powerdns-admin.nix"
  "/services/hardware/powerstation.nix"
  "/services/networking/pppd.nix"
  "/services/misc/preload.nix"
  [
    "/services/web-apps/pretalx.nix"
    {
      services = {
        nginx = true;
        redis = true;
      };
    }
  ]
  [
    "/services/web-apps/pretix.nix"
    {
      services = {
        nginx = true;
        redis = true;
      };
    }
  ]
  [
    "/services/printing/cups-pdf.nix"
    { hardware = true; }
  ]
  "/services/misc/private-gpt.nix"
  "/services/networking/privoxy.nix"
  "/services/monitoring/prometheus/alertmanager-gotify-bridge.nix"
  "/services/monitoring/prometheus/alertmanager-irc-relay.nix"
  "/services/monitoring/prometheus/alertmanager-webhook-logger.nix"
  "/services/networking/prosody.nix"
  "/services/mail/protonmail-bridge.nix"
  "/services/mail/public-inbox.nix"
  "/services/misc/pufferpanel.nix"
  [
    "/services/audio/pulseaudio.nix"
    [
      [
        0
        { services = true; }
      ]
    ]
  ]
  "/services/misc/pykms.nix"
  "/services/networking/pyload.nix"
  "/services/games/quake3-server.nix"
  "/services/networking/quicktun.nix"
  "/services/networking/radicale.nix"
  [
    "/services/misc/radicle.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/networking/rathole.nix"
  "/services/web-apps/readeck.nix"
  "/services/networking/realm.nix"
  [
    "/services/misc/redlib.nix"
    [
      [
        0
        { services = true; }
      ]
    ]
  ]
  "/services/misc/redmine.nix"
  "/services/networking/redsocks.nix"
  "/services/misc/renovate.nix"
  "/services/networking/resilio.nix"
  "/services/backup/restic-rest-server.nix"
  "/services/web-apps/rimgo.nix"
  "/services/misc/rkvm.nix"
  "/services/misc/rmfakecloud.nix"
  "/services/networking/routedns.nix"
  "/services/networking/routinator.nix"
  "/services/misc/rshim.nix"
  "/services/mail/rspamd-trainer.nix"
  [
    "/services/web-apps/rss-bridge.nix"
    { services = true; }
  ]
  "/services/mail/rss2email.nix"
  "/services/development/rstudio-server/default.nix"
  "/services/network-filesystems/rsyncd.nix"
  [ "/services/logging/rsyslogd.nix" ]
  "/services/torrent/rtorrent.nix"
  "/services/monitoring/rustdesk-server.nix"
  "/services/web-servers/rustus.nix"
  "/services/admin/salt/master.nix"
  "/services/backup/sanoid.nix"
  "/services/web-apps/screego.nix"
  [
    "/services/monitoring/scrutiny.nix"
    {
      services = {
        smartd = true;
      };
    }
  ]
  "/services/scheduling/scx.nix"
  "/services/networking/seafile.nix"
  [
    "/services/networking/searx.nix"
    {
      services = {
        redis = true;
        uwsgi = true;
      };
    }
  ]
  "/services/desktops/seatd.nix"
  [
    "/services/web-servers/send.nix"
    {
      services = {
        redis = true;
      };
    }
  ]
  "/services/security/shibboleth-sp.nix"
  "/services/web-apps/shiori.nix"
  "/services/web-apps/silverbullet.nix"
  "/services/networking/sing-box.nix"
  "/services/security/sks.nix"
  [
    "/services/web-apps/slskd.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  [
    "/services/computing/slurm/slurm.nix"
    {
      services = {
        munge = true;
      };
    }
  ]
  [
    "/services/networking/smokeping.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/misc/snapper.nix"
  "/services/audio/snapserver.nix"
  [
    "/services/web-apps/snipe-it.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  "/services/monitoring/snmpd.nix"
  "/services/networking/snowflake-proxy.nix"
  "/services/misc/soft-serve.nix"
  "/services/networking/soju.nix"
  "/services/search/sonic-server.nix"
  [
    "/services/misc/sourcehut"
    {
      services = {
        nginx = true;
        redis = true;
      };
    }
    [
      13
      12
      11
      10
    ]
  ]
  "/services/audio/spotifyd.nix"
  "/services/networking/sslh.nix"
  "/services/security/sslmate-agent.nix"
  "/services/misc/sssd.nix"
  "/services/mail/stalwart-mail.nix"
  "/services/web-servers/stargazer.nix"
  "/services/web-apps/stash.nix"
  "/services/web-servers/static-web-server.nix"
  "/services/security/step-ca.nix"
  "/services/web-apps/stirling-pdf.nix"
  "/services/hardware/supergfxd.nix"
  "/services/networking/suricata/default.nix"
  "/services/web-apps/suwayomi-server.nix"
  "/services/system/swapspace.nix"
  [
    "/services/mail/sympa.nix"
    {
      services = {
        mysql = true;
        nginx = true;
        postgresql = true;
      };
    }
  ]
  "/services/backup/syncoid.nix"
  [ "/services/logging/syslog-ng.nix" ]
  "/services/misc/sysprof.nix"
  "/services/desktops/system76-scheduler.nix"
  "/services/system/systemd-lock-handler.nix"
  "/services/misc/tabby.nix"
  [
    "/services/networking/tailscale-derper.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  [
    "/services/networking/tailscale.nix"
    {
      networking = {
        dhcpcd = true;
      };
    }
  ]
  "/services/networking/tailscale-auth.nix"
  "/services/misc/tandoor-recipes.nix"
  "/services/security/tang.nix"
  "/services/misc/taskserver"
  "/services/networking/teamspeak3.nix"
  "/services/networking/technitium-dns-server.nix"
  "/services/desktops/telepathy.nix"
  "/services/networking/thelounge.nix"
  "/services/databases/tigerbeetle.nix"
  "/services/search/tika.nix"
  "/services/networking/tinc.nix"
  "/services/networking/tinyproxy.nix"
  "/services/networking/tmate-ssh-server.nix"
  "/services/web-servers/tomcat.nix"
  "/services/security/tor.nix"
  "/services/x11/touchegg.nix"
  "/services/misc/tp-auto-kbbl.nix"
  "/services/misc/transfer-sh.nix"
  "/services/torrent/transmission.nix"
  "/services/hardware/trezord.nix"
  "/services/networking/trickster.nix"
  "/services/backup/tsm.nix"
  "/services/desktops/tumbler.nix"
  "/services/monitoring/tuptime.nix"
  "/services/misc/tzupdate.nix"
  "/services/hardware/usbmuxd.nix"
  "/services/x11/unclutter.nix"
  [
    "/services/monitoring/unpoller.nix"
    [
      [
        0
        { services = true; }
      ]
    ]
  ]
  "/services/monitoring/uptime-kuma.nix"
  "/services/x11/urxvtd.nix"
  "/services/hardware/usbrelayd.nix"
  "/services/system/userborn.nix"
  "/services/networking/v2raya.nix"
  "/services/video/v4l2-relayd.nix"
  [
    "/services/security/vaultwarden/default.nix"
    [
      [
        0
        { services = true; }
      ]
    ]
  ]
  "/services/networking/veilid.nix"
  "/services/monitoring/vnstat.nix"
  [
    "/services/development/vsmartcard-vpcd.nix"
    { services = true; }
  ]
  "/services/web-apps/wakapi.nix"
  "/services/misc/wastebin.nix"
  "/services/monitoring/watchdogd.nix"
  "/services/network-filesystems/webdav.nix"
  "/services/network-filesystems/webdav-server-rs.nix"
  [
    "/services/web-apps/weblate.nix"
    {
      services = {
        nginx = true;
        redis = true;
      };
    }
  ]
  "/services/misc/weechat.nix"
  "/services/networking/wg-netmanager.nix"
  "/services/web-apps/wiki-js.nix"
  "/services/video/wivrn.nix"
  "/services/continuous-integration/woodpecker/agents.nix"
  "/services/continuous-integration/woodpecker/server.nix"
  "/services/misc/workout-tracker.nix"
  "/services/networking/wstunnel.nix"
  "/services/home-automation/wyoming/satellite.nix"
  "/services/misc/xmrig.nix"
  "/services/games/xonotic.nix"
  "/services/x11/xscreensaver.nix"
  [
    "/services/x11/xserver.nix"
    [
      6
      5
      4
      3
      7
      8
      9
      10
      11
    ]
  ]
  [
    "/services/x11/desktop-managers/budgie.nix"
    {
      services = {
        colord = true;
        dleyna-renderer = true;
        dleyna-server = true;
        libinput = true;
        system-config-printer = true;
        upower = true;
        xserver = {
          displayManager = true;
        };
      };
    }
  ]
  [
    "/services/x11/desktop-managers/enlightenment.nix"
    {
      services = {
        libinput = true;
        upower = true;
      };
    }
  ]
  "/services/x11/desktop-managers/lumina.nix"
  [
    "/services/x11/desktop-managers/lxqt.nix"
    {
      programs = true;
      services = {
        libinput = true;
        upower = true;
      };
    }
  ]
  "/services/x11/desktop-managers/retroarch.nix"
  "/services/x11/desktop-managers/none.nix"
  [
    "/services/x11/desktop-managers/default.nix"
    [ ]
  ]
  [
    "/services/x11/desktop-managers/xfce.nix"
    {
      programs = {
        gdk-pixbuf = true;
        gnupg = true;
      };
      services = {
        colord = true;
        libinput = true;
        system-config-printer = true;
        upower = true;
      };
    }
  ]
  "/services/x11/display-managers/gdm.nix"
  [
    "/services/x11/display-managers/lightdm.nix"
    [
      8
      9
    ]
  ]
  [
    "/services/x11/display-managers/lightdm-greeters/lomiri.nix"
    {
      services = {
        xserver = {
          displayManager = {
            lightdm = {
              greeters = true;
            };
          };
        };
      };
    }
  ]
  [
    "/services/x11/window-managers/default.nix"
    [ ]
  ]
  "/services/x11/display-managers/sx.nix"
  [ "/services/x11/display-managers/xpra.nix" ]
  "/services/x11/window-managers/ragnarwm.nix"
  "/services/x11/window-managers/none.nix"
  "/services/x11/window-managers/xmonad.nix"
  [
    "/services/networking/yggdrasil.nix"
    {
      networking = {
        dhcpcd = true;
      };
    }
  ]
  "/services/networking/yggdrasil-jumper.nix"
  [
    "/services/web-apps/your_spotify.nix"
    {
      services = {
        mongodb = true;
        nginx = true;
      };
    }
  ]
  [
    "/services/web-apps/youtrack.nix"
    {
      services = {
        nginx = true;
      };
    }
  ]
  "/services/misc/ytdl-sub.nix"
  [
    "/services/security/yubikey-agent.nix"
    { services = true; }
  ]
  [
    "/services/development/zammad.nix"
    {
      services = {
        redis = true;
      };
    }
  ]
  "/services/networking/zapret.nix"
  "/services/desktops/zeitgeist.nix"
  "/services/networking/zeronet.nix"
  "/services/backup/zfs-replication.nix"
  "/services/home-automation/zigbee2mqtt.nix"
  "/services/web-apps/zipline.nix"
  "/services/web-apps/zitadel.nix"
  "/services/backup/znapzend.nix"
  [
    "/services/misc/zoneminder.nix"
    {
      services = {
        nginx = true;
        phpfpm = true;
      };
    }
  ]
  "/services/system/zram-generator.nix"
  "/services/backup/zrepl.nix"
  "/services/home-automation/zwave-js.nix"
  "/services/home-automation/zwave-js-ui.nix"
  "/system/activation/specialisation.nix"
  "/system/activation/activatable-system.nix"
  "/system/activation/switchable-system.nix"
  [
    "/system/etc/etc-activation.nix"
    [ ]
  ]
  "/virtualisation/build-vm.nix"
  "/system/boot/uki.nix"
  "/installer/tools/tools.nix"
  "/image/images.nix"
  [ "/system/build.nix" ]
  "/tasks/filesystems/vfat.nix"
  "/misc/label.nix"
  [ "/system/activation/pre-switch-check.nix" ]
  "/system/boot/systemd/tpm2.nix"
  "/system/boot/emergency-mode.nix"
  "/system/boot/systemd/shutdown.nix"
  "/system/boot/systemd/nspawn.nix"
  [ "/testing/service-runner.nix" ]
  "/system/boot/systemd/sysupdate.nix"
  "/system/boot/systemd/sysusers.nix"
  [ "/config/ldap.nix" ]
  "/config/mysql.nix"
  "/virtualisation/containers.nix"
  "/virtualisation/cri-o.nix"
  "/virtualisation/incus-agent.nix"
  "/virtualisation/incus.nix"
  "/virtualisation/kvmgt.nix"
  "/virtualisation/lxc.nix"
  "/virtualisation/lxcfs.nix"
  [
    "/virtualisation/podman/default.nix"
    [
      1
      0
    ]
  ]
  [
    "/virtualisation/vmware-guest.nix"
    [
      [
        0
        { virtualisation = true; }
      ]
    ]
  ]
  "/virtualisation/openvswitch.nix"
  "/virtualisation/xen-dom0.nix"
  "/config/xdg/portals/lxqt.nix"
  "/config/xdg/portals/wlr.nix"
  "/config/xdg/terminal-exec.nix"
  [ "/programs/vim.nix" ]
  "/misc/meta.nix"
]
