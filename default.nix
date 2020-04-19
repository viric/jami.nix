{ pkgs ? import <nixpkgs> }:

let
  jamiOverlay = self: super: {
    opendht = super.callPackage ./opendht.nix {};
    pjsip = super.callPackage ./pjsip.nix {};
    ring-daemon-src = super.callPackage ./daemon-src.nix {};
    ring-daemon = self.callPackage ./daemon.nix {};
  };
  jamiPkgs = pkgs { overlays = [jamiOverlay]; };
in

jamiPkgs
