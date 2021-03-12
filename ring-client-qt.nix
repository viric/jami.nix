{ stdenv, fetchgit
, qtbase, qmake, qtquickcontrols2, qtwebengine, qrencode, ring-daemon
, qtgraphicaleffects, networkmanager, pkgconfig
, wrapQtAppsHook
, lrc
}:

stdenv.mkDerivation rec {
  pname = "ring-client-qt";
  version = src.rev;
  buildInputs =
    [ qtbase qmake qtquickcontrols2 qtwebengine lrc qrencode
    wrapQtAppsHook qtgraphicaleffects networkmanager pkgconfig
    ];

  src = fetchgit {
    url = "https://review.jami.net/jami-client-qt";
    rev = "1d026c7bfedf447cc7a4de9574e46a22936ffbce";
    sha256 = "0fsnhgdlcyg6ns1sr4c9in5p9zskph74k34jjw0r8v7i6aq1arxv";
  };

  preBuild = ''
    cp -r ${ring-daemon.src} ../daemon
    cp -r ${lrc.src} ../lrc
  '';

  qmakeFlags = "LRC=${lrc}";

  meta = with stdenv.lib; {
    description = "Jami Qt client";
    homepage = "https://jami.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
