{ pkgs ? import <nixpkgs> }:

let
  patchdir = ./patches;
  jamiOverlay = self: super: {
    ffmpeg = super.ffmpeg.override {
      patches = [ "${patchdir}/change-RTCP-ratio.patch" ];
    };
    /*
    gnutls = super.gnutls.overrideAttrs (oldAttrs: rec {
      patches = oldAttrs.patches ++ [ "${patchdir}/read-file-limits.h.patch" ];
      doCheck = false;
    });
    */
    # asio = self.callPackage ./asio.nix { };
    opendht = self.callPackage ./opendht.nix {
      openssl = self.libressl;
    };
    pjsip = self.callPackage ./pjsip.nix {
      patches = let
        patchdir = self.ring-daemon.src + "/contrib/src/pjproject";
        in
        [
          "${patchdir}/0001-rfc6544.patch"
          "${patchdir}/0002-rfc2466.patch"
          "${patchdir}/0003-add-tcp-keep-alive.patch"
          "${patchdir}/0004-multiple_listeners.patch"
          "${patchdir}/0005-fix_ebusy_turn.patch"
          "${patchdir}/0006-ignore_ipv6_on_transport_check.patch"
          "${patchdir}/0007-pj_ice_sess.patch"
          "${patchdir}/0007-upnp-srflx-nat-assisted-cand.patch"
          "${patchdir}/0008-fix_ioqueue_ipv6_sendto.patch"
          "${patchdir}/0009-add-config-site.patch"
          "${patchdir}/0011-fix-tcp-death-detection.patch"
          "${patchdir}/0012-fix-turn-shutdown-crash.patch"
          #"${patchdir}/0013-Assign-unique-local-preferences-for-candidates-with-.patch"
          "${patchdir}/0014-Add-new-compile-time-setting-PJ_ICE_ST_USE_TURN_PERM.patch"
          "${patchdir}/0015-update-local-preference-for-peer-reflexive-candidate.patch"
          "${patchdir}/0016-use-addrinfo-instead-CFHOST.patch"
          #"${patchdir}/0001-win-config.patch"
          #"${patchdir}/0002-win-vs-gnutls.patch"
          #"${patchdir}/0003-win-vs2017-props.patch"
        ];
    };
    restinio = self.callPackage ./restinio.nix {};
    ring-daemon = self.callPackage ./daemon.nix {};
    inherit (super.qt5) qttools wrapQtAppsHook;
    qtbase = super.buildEnv {
      name = "qtbase-${super.qt5.qtbase.version}-fixed";
      paths = [ super.qt5.qtbase.bin ];
    };
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
    inherit (jamiPkgs) lrc qtbase wrapQtAppsHook;
  };
  ring-client-qt = (pkgs {}).libsForQt5.callPackage ./ring-client-qt.nix {
    inherit (jamiPkgs) lrc ring-daemon;
  };

in

jamiPkgs // { inherit ring-client-gnome ring-client-qt; }
