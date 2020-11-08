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
    rev = "8f282fe14fb183e7a6e3b7de4b2ed81fd612b68c";
    sha256 = "0n4wjwj7i90vj2y71k5fqx24a00yz7xsmcds6ll0rrjrc1g7qf1d";
  };

  meta = with stdenv.lib; {
    description = "Jami LibRingClient";
    homepage = "https://jami.net/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
