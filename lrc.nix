{ stdenv, fetchgit
, autoreconfHook, pkgconfig, cmake
, ring-daemon, qtbase, qttools
}:

stdenv.mkDerivation rec {
  pname = "lrc";
  version = src.rev;
  nativeBuildInputs =
    [ cmake ];
  buildInputs =
    [ ring-daemon qtbase qttools ];

  cmakeFlags =
    # see <lrc dir>/INSTALL
    # and <lrc dir>/cmake/FindRing.cmake
    [ "-DRING_INCLUDE_DIR=${ring-daemon}/include/dring"
      "-DRING_XML_INTERFACES_DIR=${ring-daemon}/share/dbus-1/interfaces"
    ];

  src = fetchgit {
    url = "https://git.jami.net/savoirfairelinux/ring-lrc.git";
    rev = "559bbba0a9f632ae554bfe9cfc2edf72efee6b0a";
    sha256 = "0ws4r1an7kix681r0yxv32rskk63zgp0lbdgn7dsdx2r4gypx3p9";
  };

  meta = with stdenv.lib; {
    description = "Jami LibRingClient";
    homepage = "https://jami.net/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
