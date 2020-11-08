{ stdenv, fetchgit
, qtbase, qmake, qtquickcontrols2, qtwebengine, qrencode, ring-daemon
, qtgraphicaleffects
, wrapQtAppsHook
, lrc
}:

stdenv.mkDerivation rec {
  pname = "ring-client-qt";
  version = src.rev;
  buildInputs =
    [ qtbase qmake qtquickcontrols2 qtwebengine lrc qrencode
    wrapQtAppsHook qtgraphicaleffects
    ];

  src = fetchgit {
    url = "https://review.jami.net/jami-client-qt";
    rev = "310adb9aa1b6db4d238dd22aa2119ce5fbabdea7";
    sha256 = "1bmarf9kygw3lsxs2lpxmz4yhdpqcamwps77cpd0z736j2ky939w";
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
