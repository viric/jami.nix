{ stdenv, fetchgit
, cmake, pkgconfig, git, doxygen, graphviz
, lrc, gtk3, qtbase, pcre, libpthreadstubs, libXdmcp
, clutter, clutter-gtk, libqrencode, webkitgtk
, libnotify, libcanberra-gtk3, libappindicator-gtk3
, utillinuxMinimal, libselinux, libsepol, epoxy, at-spi2-core
, libXtst, libpsl, networkmanager
}:

stdenv.mkDerivation rec {
  pname = "ring-client-gnome";
  version = src.rev;
  nativeBuildInputs = [ cmake pkgconfig git doxygen graphviz ];
  buildInputs =
    [ lrc gtk3 qtbase pcre libpthreadstubs libXdmcp clutter
      clutter-gtk libqrencode webkitgtk libnotify
      libcanberra-gtk3 libappindicator-gtk3
      utillinuxMinimal # for 'mount' package (lib?)
      libselinux libsepol epoxy at-spi2-core libXtst
      libpsl networkmanager
    ];

  src = fetchgit {
    url = "https://git.jami.net/savoirfairelinux/ring-client-gnome.git";
    rev = "f8a77091b84d3bcbe415db0e4e26f70eb7c7e18e";
    sha256 = "1252nqsqmcph548b4fba5qg8ic27l5b4h0s6m6wy8qbb9dg99b1q";
  };

  preConfigure = ''
    cmd="cp ${lrc.src}/src/web-chatview/* ./web/"
    echo "copying: $cmd"
    $cmd
  '';

  meta = with stdenv.lib; {
    description = "Jami Gnome client";
    homepage = "https://jami.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
