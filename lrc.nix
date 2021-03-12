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
    rev = "f354e8b212b49f871fb4540e56f9cb8e664c261b";
    sha256 = "10cq4g0m23ag4m8wq3ab66g38j0x0kw6zzg4xpiyy6nhw4r421gp";
  };

  meta = with stdenv.lib; {
    description = "Jami LibRingClient";
    homepage = "https://jami.net/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
