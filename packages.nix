# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  inputs,
  pkgs,
}:
let
  sources = pkgs.callPackage ./_sources/generated.nix { };
  system = pkgs.stdenv.hostPlatform.system;
  makeOverridable =
    pkg: attrF:
    (pkg.override (pkgs.lib.intersectAttrs pkg.override.__functionArgs pkgs)).overrideAttrs attrF;

  karabiner-branch = import inputs.karabiner-branch {
    inherit system;
    # The version of Karabiner-Elements to use.
    # You can override the default version here if you want.
    # version = "14.6.0";
  };
in

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays
  ghostty-bin = pkgs.callPackage ./pkgs/ghostty {
    source = sources.ghostty;
    sourceRoot = ".";
  };
  ghostty-nightly-bin = pkgs.callPackage ./pkgs/ghostty {
    source = sources.ghostty-nightly;
    sourceRoot = ".";
  };
  zen-browser = pkgs.callPackage ./pkgs/zen-browser {
    source = sources.zen;
    sourceRoot = "Zen.app";
    applicationName = "Zen";
  };
  zen-browser-twilight = pkgs.callPackage ./pkgs/zen-browser {
    source = sources.zen-twilight;
    applicationName = "Twilight";
    sourceRoot = "Twilight.app";
  };
  bartender = pkgs.callPackage ./pkgs/bartender {
    source = sources.bartender-6;
    sourceRoot = ".";
  };
  hardlink = pkgs.callPackage ./pkgs/hardlink {
  };
  yabai = pkgs.callPackage ./pkgs/yabai {
    source = sources.yabai;

  };
  desktoppr = builtins.trace "desktoppr is now in nixpkgs" pkgs.callPackage ./pkgs/desktoppr {
  };
  #kanata = makeOverridable karabiner-branch.kanata (oldAttrs: {
  #  inherit (sources.kanata) src version;
  #  passthru.darwinDriverVersion = "6.2.0";
  #  cargoLock = sources.kanata.cargoLock;
  #});
  karabiner-dk = makeOverridable karabiner-branch.karabiner-dk (oldAttrs: {
    inherit (sources.karabiner-dk) src;
    sourceVersion = sources.karabiner-dk.version;
  });
  kanata-vk-agent = pkgs.callPackage ./pkgs/kanata-vk-agent {
    source = sources.kanata-vk-agent;
  };

  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
