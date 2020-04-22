{ pkgs ? import <nixpkgs> }:

let
  patchdir = ./patches;
  jamiOverlay = self: super: {
    ffmpeg = super.ffmpeg.override {
      patches = [ "${patchdir}/change-RTCP-ratio.patch" ];
    };
    gnutls = super.gnutls.overrideAttrs (oldAttrs: rec {
      patches = oldAttrs.patches ++ [ "${patchdir}/read-file-limits.h.patch" ];
      doCheck = false;
    });
    opendht = self.callPackage ./opendht.nix {};
    pjsip = self.callPackage ./pjsip.nix {};
    restinio = self.callPackage ./restinio.nix {};
    ring-daemon = self.callPackage ./daemon.nix {};
    inherit (super.qt5) qtbase qttools;
    lrc = self.callPackage ./lrc.nix {};
  };
  jamiPkgs = pkgs { overlays = [jamiOverlay]; };

  # we only bring lrc and qtbase from 'jamiPkgs' because it
  # overrides gnutls, which is a dependency of webkitgtk,
  # which is a dependency of the gnome client. not doing this
  # forces us to build webkitgtk instead of having a cache
  # hit, and that thing just takes forever to build.
  # hopefully that won't bite us in the ass, but the tls
  # patches only seem required for the daemon, hopefully it's
  # fine.
  ring-client-gnome = (pkgs {}).callPackage ./ring-client-gnome.nix {
    inherit (jamiPkgs) lrc qtbase;
  };

in

jamiPkgs // { inherit ring-client-gnome; }
