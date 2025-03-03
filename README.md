# Teanyth - NixOS Configuration

> [!CAUTION]
> These dotfiles are heavily tailored to my needs and will likely not work out
> of the box on your machine. Installing them without inspecting them first is
> likely to almost fully **wipe your computer**.

This is my personal NixOS configuration for my machines. You can find them under
the [hosts](hosts) folder.

You should really not be trying to install them, but you are free to take
inspiration from them. Some small parts are not included and are in a separate
private repository. This includes my secrets (although encrypted with
[sops-nix](https://github.com/Mic92/sops-nix)) and some slightly sensitive data
not worth encrypting.

## Main Features

- Theme switcher without the need to rebuild, fully integrated with Nix using
  custom-made, faster specialisations
- Encrypted secrets using [sops-nix](https://github.com/Mic92/sops-nix)
- Very modularized configuration
- Hybrid [home-manager](https://github.com/nix-community/home-manager) setup,
  meaning it can be rebuilt both as standalone and as a NixOS module.
- Auto-generated color schemes from wallpapers using
  [wallust](https://codeberg.org/explosion-mental/wallust)
- Rice system allowing for a single rice configuration to generate various
  themes automatically from wallpapers using the theme switcher
- Additional flake outputs, for example for my [Neovim](https://neovim.io/)
  configuration: `nix run github:ToborWinner/teanyth#neovim`
- [Impermanence](https://github.com/nix-community/impermanence) setup
- [deploy-rs](https://github.com/serokell/deploy-rs) setup for my Raspberry Pi 3
  B+

### Theme switcher

One can achieve a theme switcher by using
[home-manager specialisations](https://github.com/nix-community/home-manager/blob/fcac3d6d88302a5e64f6cb8014ac785e08874c8d/modules/misc/specialisation.nix#L38),
but they would be slow because for each specialisation Nix needs to evaluate the
`home.activationPackage` option, which depends on many other options. Since for
a theme switcher you only need to swap files, I made my own specialisations that
only evaluate `home.file`, which is a bit faster. This can be seen
[here](core/hm/theme.nix).

### Rice system

I want to be able to swap between rices by rebuilding. I consider changing rice
to be a bigger configuration change than changing theme. Changing rice requires
rebuilding. All rices are defined in the [rices](rices) folder and the active
one is decided by the `pers.rice.enabled` home-manager option.

For a specific rice, one can set `pers.rice.themesFromWallpapers` and
`pers.rice.wallpapers` to automatically generate themes for the theme switcher
from the wallpapers using the `pers.rice.colorBackend` backend (such as
[wallust](https://codeberg.org/explosion-mental/wallust)). This will make the
`pers.rice.currentTheme` option available, which contains the colors returned by
the backend. One can then use these options to configure the rice and theme
switching will automatically be implemented.

### Neovim flake output

Neovim wrapped with my configuration is exposed as a flake output in the form of
a package.

This means my Neovim configuration can be tried out with:

```bash
nix run github:ToborWinner/teanyth#neovim
```

### Flake Templates

Whenever I start a new project, for example in
[Rust](https://www.rust-lang.org/), I can use my flake templates to get the
project started with the main files and a development shell:

```bash
nix flake init -t github:ToborWinner/teanyth#rust
```

### Pinned nix registry with aliases

My nix registry is pinned to my configuration, meaning that when I run
`nix shell nixpkgs#hello`, the `hello` package will be from my flake's nixpkgs
version (the one that was used to build the current active system).

This is my registry:

- `nixpkgs` -> my flake's nixpkgs
- `n` -> same as `nixpkgs`
- `${settings.username}` -> my flake

This means that I can use my templates simply by using my username:

```bash
nix flake init -t tobor#rust
```

or run a package from nixpkgs by only writing `n`:

```bash
nix run n#hello
```

### Hybrid home-manager setup

I have [home-manager](https://github.com/nix-community/home-manager) setup as a
NixOS module, but this means that to update a small change in my user
environment I need to rebuild the entire system. That's why I have a function
that re-exports my NixOS module home-manager configurations as
`homeConfigurations` in my flake.

This allows me to run the following to quickly test a change to the user
environment:

```bash
home-manager switch --flake tobor#nixos-asahi
```

which I can later finalize by fully rebuilding.

## Structure

My configuration follows a very modular structure:

- [hosts/](hosts) contains my various hosts, each containing a configuration.nix
  that enables various modules
- [core/](core) contains core functionalities of my nix configurations, such as
  my [custom library](core/lib/default.nix) and main modules under the
  appropriate [core/nixos/](core/hm) and [core/hm/](core/hm) directories.
- [modules/](modules) contains three sub-folders for my
  [NixOS modules](modules/nixos), [home-manager modules](modules/hm) and
  [Neovim modules](modules/neovim) (using
  [nvf](https://github.com/NotAShelf/nvf))
- [pkgs/](pkgs) contains some derivations and scripts that are added to `pkgs`
  under `pkgs.pers` and are also exported by my flake
- [rices/](rices) contains my rices
- [templates/](templates) contains the templates made available by my flake
- [wallpapers/](wallpapers) is rather self-explanatory

Most, if not all, of the options I define are under the `pers` attribute to
easily distinguish them from nixpkgs and home-manager's options. This also
applies to `lib`: my custom lib is added under `lib.pers`. As previously
mentioned, it also applies to `pkgs`.

## License

The contents of my configuration, aside from wallpapers, are licensed under the
[MIT LICENSE](LICENSE).
